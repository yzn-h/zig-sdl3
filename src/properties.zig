// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Properties type enum.
pub const Type = enum(c_uint) {
	Pointer = C.SDL_PROPERTY_TYPE_POINTER,
	String = C.SDL_PROPERTY_TYPE_STRING,
	Number = C.SDL_PROPERTY_TYPE_NUMBER,
	Float = C.SDL_PROPERTY_TYPE_FLOAT,
	Boolean = C.SDL_PROPERTY_TYPE_BOOLEAN,
};

/// SDL properties group. Properties can be added or removed at runtime.
pub const Group = struct {
	value: C.SDL_PropertiesID,

	/// Get the global SDL properties.
	pub fn getGlobal() !Group {
		const ret = C.SDL_GetGlobalProperties();
		if (ret == 0)
			return error.SdlError;
		return Group{ .value = ret };
	}

	/// Create a group of properties.
	pub fn init() !Group {
		const ret = C.SDL_CreateProperties();
		if (ret == 0)
			return error.SdlError;
		return Group{ .value = ret };
	}

	/// Copy and replace all properties in destination with ones in this one. Will not copy properties that require cleanup.
	pub fn copyTo(
		self: Group,
		dest: Group,
	) !void {
		const ret = C.SDL_CopyProperties(
			self.value,
			dest.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Lock a group of properties.
	pub fn lock(
		self: Group,
	) !void {
		const ret = C.SDL_LockProperties(
			self.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Unlock a group of properties.
	pub fn unlock(
		self: Group,
	) !void {
		const ret = C.SDL_UnlockProperties(
			self.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set a pointer property in a group of properties with a cleanup function that is called when the property is deleted.
	pub fn setPointerPropertyWithCleanup(
		self: Group,
		ValueType: type,
		UserData: type,
		name: [:0]const u8,
		value: ?*ValueType,
		cb: ?*const fn (user_data: *UserData, value: *ValueType) callconv(.C) void,
		user_data: *UserData,
	) !void {
		const ret = C.SDL_SetPointerPropertyWithCleanup(
			self.value,
			name,
			value,
			if (cb) |val| @ptrCast(val) else null,
			user_data,
		);
		if (!ret)
			return error.SdlError;
	}

	/// If the property group has a property.
	pub fn has(
		self: Group,
		name: [:0]const u8,
	) bool {
		const ret = C.SDL_HasProperty(
			self.value,
			name,
		);
		return ret;
	}

	/// Get the type of property.
	pub fn getType(
		self: Group,
		name: [:0]const u8,
	) ?Type {
		const ret = C.SDL_GetPropertyType(
			self.value,
			name,
		);
		if (ret == C.SDL_PROPERTY_TYPE_INVALID)
			return null;
		return @enumFromInt(ret);
	}

	/// Clear a property from the group.
	pub fn clear(
		self: Group,
		name: [:0]const u8,
	) !void {
		const ret = C.SDL_ClearProperty(
			self.value,
			name,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Destroy the group of properties.
	pub fn deinit(
		self: Group,
	) void {
		const ret = C.SDL_DestroyProperties(
			self.value,
		);
		_ = ret;
	}

	/// Set a property.
    pub fn set(
        self: Group,
        name: [:0]const u8,
        value: Property,
    ) !void {
        const ret = switch (value) {
            .Pointer => |pt| C.SDL_SetPointerProperty(self.value, name, pt),
            .String => |str| C.SDL_SetStringProperty(self.value, name, str),
            .Number => |num| C.SDL_SetNumberProperty(self.value, name, num),
            .Float => |num| C.SDL_SetFloatProperty(self.value, name, num),
            .Boolean => |val| C.SDL_SetBooleanProperty(self.value, name, val),
        };
        if (!ret)
            return error.SdlError;
    }

	/// Get a property.
    pub fn get(
        self: Group,
        name: [:0]const u8,
    ) ?Property {
        return switch (self.getPropertyType(name)) {
            C.SDL_PROPERTY_TYPE_INVALID => null,
            C.SDL_PROPERTY_TYPE_POINTER => Property{ .Pointer = C.SDL_GetPointerProperty(self.value, name, null) },
            C.SDL_PROPERTY_TYPE_STRING => Property{ .String = C.SDL_GetStringProperty(self.value, name, "") },
            C.SDL_PROPERTY_TYPE_NUMBER => Property{ .Number = C.SDL_GetNumberProperty(self.value, name, 0) },
            C.SDL_PROPERTY_TYPE_FLOAT => Property{ .Float = C.SDL_GetFloatProperty(self.value, name, 0) },
            C.SDL_PROPERTY_TYPE_BOOLEAN => Property{ .Boolean = C.SDL_GetBooleanProperty(self.value, name, false) },
        };
    }

	/// Get all properties in the group. Returned map is owned.
    pub fn getAll(
        self: Group,
        allocator: std.mem.Allocator,
    ) !std.StringHashMap(Property) {
        var ret = std.StringArrayHashMap(Property).init(allocator);
        if (!C.SDL_EnumerateProperties(self.value, propertiesEnumerateCallback, &ret))
            return error.SdlError;
        return ret;
    }
};

/// Property.
pub const Property = union(Type) {
    Pointer: ?*anyopaque,
    String: [:0]const u8,
    Number: i64,
    Float: f32,
    Boolean: bool,
};

/// Used for adding properties to a list.
fn propertiesEnumerateCallback(user_data: *std.StringHashMap(Property), id: C.SDL_PropertiesID, name: [*c]const u8) callconv(.C) void {
    const group = Group{ .value = id };
    if (group.get(name)) |val|
        user_data.put(name, val) catch {};
}
