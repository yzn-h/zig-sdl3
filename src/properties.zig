const C_SDL = @import("c_sdl.zig").C_SDL;
const Error = @import("error.zig").Error;
const std = @import("std");

/// An ID for properties.
const ID = C_SDL.SDL_PropertiesID;

/// Properties type enum.
pub const Type = enum(c_int) {
    Invalid = C_SDL.SDL_PROPERTY_TYPE_INVALID,
    Pointer = C_SDL.SDL_PROPERTY_TYPE_POINTER,
    String = C_SDL.SDL_PROPERTY_TYPE_STRING,
    Number = C_SDL.SDL_PROPERTY_TYPE_NUMBER,
    Float = C_SDL.SDL_PROPERTY_TYPE_FLOAT,
    Boolean = C_SDL.SDL_PROPERTY_TYPE_BOOLEAN,
};

/// Callback for enumerating properies.
fn enumeratePropertiesCallback(user_data: ?*anyopaque, id: ID, name: [*c]const u8) callconv(.C) void {
    const cb_data: *struct {
        cb: *const fn (ud: ?*anyopaque, group: Group, name: []const u8) void,
        data: ?*anyopaque,
    } = @ptrCast(@alignCast(user_data));
    cb_data.cb(cb_data.data, Group.fromID(id), std.mem.span(name));
}

/// Callback context for adding properties to a set.
const PropertySetContext = struct {
    set: *std.StringHashMap(void),
    err: ?std.mem.Allocator.Error,
};

/// Callback for adding properties to a set.
fn propertyAddToSetCallback(user_data: *PropertySetContext, group: Group, name: []const u8) void {
    if (user_data.set.put(name, {})) {} else |err| {
        user_data.err = err;
    }
    _ = group;
}

/// SDL properties group. Properties can be added or removed at runtime.
pub const Group = struct {
    const Self = @This();
    /// An invalid/null group.
    pub const invalid = Group{ .id = 0 };
    id: ID,

    /// Copy and replace all properties in destination with ones in this one. Will not copy properties that require cleanup.
    pub fn copyTo(self: Self, dest: Self) !void {
        if (!C_SDL.SDL_CopyProperties(self.id, dest.id))
            return error.SDLError;
    }

    /// Destroy the group of properties.
    pub fn deinit(self: Self) void {
        C_SDL.SDL_DestroyProperties(self.id);
    }

    /// Fetch a properties enumeration callback.
    pub fn EnumerateCallback(comptime UserData: type) type {
        return *const fn (user_data: *UserData, group: Self, name: []const u8) void;
    }

    /// Enumerate all properties in the group.
    pub fn enumerate(self: Self, comptime UserData: type, user_data: *UserData, callback: EnumerateCallback(UserData)) !void {
        var cb_data = .{
            callback,
            user_data,
        };
        if (!C_SDL.SDL_EnumerateProperties(self.id, enumeratePropertiesCallback, @ptrCast(&cb_data)))
            return error.SDLError;
    }

    /// Check if a property exists.
    pub fn exists(self: Self, name: [:0]const u8) bool {
        return C_SDL.SDL_HasProperty(self.id, name);
    }

    /// Create a group from an SDL ID.
    fn fromID(id: ID) Self {
        return .{ .id = id };
    }

    /// Get a set containing the name of all properties. Must free the set yourself.
    pub fn getAll(self: Self, allocator: std.mem.Allocator) !std.StringHashMap(void) {
        var ret = std.StringHashMap(void).init(allocator);
        var ctx = PropertySetContext{
            .set = &ret,
            .err = null,
        };
        try self.enumerate(PropertySetContext, &ctx, propertyAddToSetCallback);
        if (ctx.err) |err|
            return err;
        return ret;
    }

    /// Get a bool property. Null is returned if the bool does not exist.
    pub fn getBool(self: Self, name: [:0]const u8) ?bool {
        if (self.exists(name))
            return C_SDL.SDL_GetBooleanProperty(self.id, name, false);
        return null;
    }

    /// Get a float property. Null is returned if the float does not exist.
    pub fn getFloat(self: Self, name: [:0]const u8) ?f32 {
        if (self.exists(name))
            return C_SDL.SDL_GetFloatProperty(self.id, name, 0.0);
        return null;
    }

    /// Get a number property. Null is returned if the number does not exist.
    pub fn getNumber(self: Self, name: [:0]const u8) ?i64 {
        if (self.exists(name))
            return C_SDL.SDL_GetNumberProperty(self.id, name, 0);
        return null;
    }

    /// Get a pointer property. Null is returned if pointer does not exist.
    pub fn getPointer(self: Self, name: [:0]const u8, comptime Data: type) ?*Data {
        if (self.exists(name))
            return @ptrCast(@alignCast(C_SDL.SDL_GetPointerProperty(self.id, name, null).?));
        return null;
    }

    /// Get a string property. Null is returned if the string does not exist.
    pub fn getString(self: Self, name: [:0]const u8) ?[]const u8 {
        var raw = C_SDL.SDL_GetStringProperty(self.id, name, 0);
        if (raw != 0)
            return std.mem.span(raw);
        return null;
    }

    /// Get the type of a property.
    pub fn getType(self: Self, name: [:0]const u8) Type {
        return @enumFromInt(C_SDL.SDL_GetPropertyType(self.id, name));
    }

    /// Get the global SDL properties.
    pub fn global() !Self {
        const id = C_SDL.SDL_GetGlobalProperties();
        if (id == 0)
            return error.SDLError;
        return fromID(id);
    }

    /// Create a new properties group. Note all properties are destroyed on SDL shutdown.
    pub fn init() !Self {
        const id = C_SDL.SDL_CreateProperties();
        if (id == 0)
            return error.SDLError;
        return fromID(id);
    }

    /// Have other locks be spinlocks until this is unlocked. Useful for setting multiple properties atomically or properties are not freed during getting. Setting a property locks.
    pub fn lock(self: Self) !void {
        if (!C_SDL.SDL_LockProperties(self.id))
            return error.SDLError;
    }

    /// Remove a property with the given name.
    pub fn remove(self: Self, name: [:0]const u8) !void {
        if (!C_SDL.SDL_ClearProperty(self.id, name))
            return error.SDLError;
    }

    /// Set a boolean value property, null for the value will delete it.
    pub fn setBoolean(self: Self, name: [:0]const u8, value: ?bool) !void {
        if (value) |val| {
            if (!C_SDL.SDL_SetBooleanProperty(self.id, name, val))
                return error.SDLError;
        } else try self.remove(name);
    }

    /// Set a float value property, null for the value will delete it.
    pub fn setFloat(self: Self, name: [:0]const u8, value: ?f32) !void {
        if (value) |val| {
            if (!C_SDL.SDL_SetFloatProperty(self.id, name, val))
                return error.SDLError;
        } else try self.remove(name);
    }

    /// Set a number value property, null for the value will delete it.
    pub fn setNumber(self: Self, name: [:0]const u8, value: ?i64) !void {
        if (value) |val| {
            if (!C_SDL.SDL_SetNumberProperty(self.id, name, val))
                return error.SDLError;
        } else try self.remove(name);
    }

    /// Set a pointer value property, null for the value will delete it.
    pub fn setPointer(self: Self, name: [:0]const u8, value: ?*anyopaque) !void {
        if (!C_SDL.SDL_SetPointerProperty(self.id, name, value))
            return error.SDLError;
    }

    /// Callback for deleting a pointer value.
    pub fn PointerCleanupCallback(comptime UserData: type, comptime Data: type) type {
        return *const fn (user_data: *UserData, data: *Data) callconv(.C) void;
    }

    /// Set a pointer with a cleanup function for when it is removed. Nulling the value here will delete it. Make sure callback and user data pointers live until property is destroyed.
    pub fn setPointerWithCleanup(self: Self, name: [:0]const u8, comptime UserData: type, user_data: *UserData, comptime Data: type, value: ?*Data, callback: ?PointerCleanupCallback(UserData, Data)) !void {
        var cb: C_SDL.SDL_CleanupPropertyCallback = null;
        if (callback) |val| {
            cb = @ptrCast(val);
        }
        if (!C_SDL.SDL_SetPointerPropertyWithCleanup(self.id, name, value, cb, user_data))
            return error.SDLError;
    }

    /// Set a string property. String will be copied, setting a null value will delete.
    pub fn setString(self: Self, name: [:0]const u8, value: ?[:0]const u8) !void {
        var str: [*c]const u8 = 0;
        if (value) |val| {
            str = val;
        }
        if (!C_SDL.SDL_SetStringProperty(self.id, name, str))
            return error.SDLError;
    }

    /// Unlock a group of properties.
    pub fn unlock(self: Self) void {
        C_SDL.SDL_UnlockProperties(self.id);
    }
};

fn arrayCleanupCallback(user_data: *u32, data: *std.ArrayList(u32)) callconv(.C) void {
    std.testing.expect(user_data.* == 3) catch std.io.getStdErr().writer().print("Invlid value found! Expected 3, got {d}.\n", .{user_data.*}) catch {};
    data.deinit();
}

fn propertyEnumerateCallback(user_data: *std.StringHashMap(Group), group: Group, name: []const u8) void {
    user_data.put(name, group) catch std.io.getStdErr().writer().print("Allocator error\n", .{}) catch {};
}

test "Properties" {
    const group = try Group.init();
    defer group.deinit();
    try std.testing.expect(!group.exists("a"));
    try std.testing.expect(group.getType("a") == .Invalid);

    // Boolean.
    try group.setBoolean("a", false);
    try std.testing.expect(group.exists("a"));
    try std.testing.expect(group.getBool("a").? == false);
    try group.setBoolean("b", true);
    try std.testing.expect(group.getBool("b").? == true);
    try std.testing.expect(group.getType("b") == .Boolean);
    try group.setBoolean("a", null);
    try std.testing.expect(group.getBool("a") == null);
    try group.remove("b");
    try std.testing.expect(group.getBool("b") == null);

    // Float.
    try group.setFloat("a", 1.0);
    try std.testing.expect(group.exists("a"));
    try std.testing.expect(group.getFloat("a").? == 1.0);
    try group.setFloat("b", -1.0);
    try std.testing.expect(group.getFloat("b").? == -1.0);
    try std.testing.expect(group.getType("b") == .Float);
    try group.setFloat("a", null);
    try std.testing.expect(group.getFloat("a") == null);
    try group.remove("b");
    try std.testing.expect(group.getFloat("b") == null);

    // Number.
    try group.setNumber("a", -55);
    try std.testing.expect(group.exists("a"));
    try std.testing.expect(group.getNumber("a").? == -55);
    try group.setNumber("b", 77);
    try std.testing.expect(group.getNumber("b").? == 77);
    try std.testing.expect(group.getType("b") == .Number);
    try group.setNumber("a", null);
    try std.testing.expect(group.getNumber("a") == null);
    try group.remove("b");
    try std.testing.expect(group.getNumber("b") == null);

    // Pointer. Sorry, no const for now.
    var num1: u32 = 3;
    var num2: i8 = 7;
    try group.setPointer("a", &num1);
    try std.testing.expect(group.exists("a"));
    try std.testing.expect(group.getPointer("a", u32).? == &num1);
    try group.setPointer("b", &num2);
    try std.testing.expect(group.getPointer("b", i8).?.* == num2);
    try std.testing.expect(group.getType("b") == .Pointer);
    try group.setPointer("a", null);
    try std.testing.expect(group.getPointer("a", u32) == null);
    try group.remove("b");
    try std.testing.expect(group.getPointer("b", i8) == null);

    // Pointer cleanup.
    var list = std.ArrayList(u32).init(std.testing.allocator);
    try list.append(3);
    try group.setPointerWithCleanup("list", u32, &num1, @TypeOf(list), &list, arrayCleanupCallback);

    // String.
    try group.setString("a", "Test 1");
    try std.testing.expect(group.exists("a"));
    try std.testing.expect(std.mem.eql(u8, group.getString("a").?, "Test 1"));
    try group.setString("b", "Test 2");
    try std.testing.expect(std.mem.eql(u8, group.getString("b").?, "Test 2"));
    try std.testing.expect(group.getType("b") == .String);
    try group.setString("a", null);
    try std.testing.expect(group.getString("a") == null);
    try group.remove("b");
    try std.testing.expect(group.getString("b") == null);

    // Lock and unlock.
    try group.lock();
    group.unlock();

    // Copy to and enumerate.
    try group.setNumber("a", 3);
    try group.setBoolean("b", false);
    try group.setString("c", "Copy test.");

    const global = try Group.global();
    try group.copyTo(global);

    var set = std.StringHashMap(Group).init(std.testing.allocator);
    defer set.deinit();
    try global.enumerate(@TypeOf(set), &set, propertyEnumerateCallback);
    try std.testing.expect(set.count() == 3); // The list property should not be copied as it has a deleter.
    try std.testing.expect(set.contains("a"));
    try std.testing.expect(set.contains("b"));
    try std.testing.expect(set.contains("c"));
    try std.testing.expect(!set.contains("d"));

    var all = try group.getAll(std.testing.allocator);
    defer all.deinit();
    try std.testing.expect(all.count() == 4);
    try std.testing.expect(all.contains("list"));
    try std.testing.expect(all.contains("a"));
    try std.testing.expect(all.contains("b"));
    try std.testing.expect(all.contains("c"));
    try std.testing.expect(!all.contains("d"));
}
