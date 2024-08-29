const C_SDL = @import("c_sdl.zig").C_SDL;
const Error = @import("error.zig");
const std = @import("std");

/// Used for initializing a subsystem.
pub const Flags = struct {
    const Self = @This();
    pub const everything = Flags{
        .timer = true,
        .audio = true,
        .video = true,
        .joystick = true,
        .haptic = true,
        .gamepad = true,
        .events = true,
        .sensor = true,
        .camera = true,
    };
    timer: bool = false,
    audio: bool = false,
    video: bool = false,
    joystick: bool = false,
    haptic: bool = false,
    gamepad: bool = false,
    events: bool = false,
    sensor: bool = false,
    camera: bool = false,

    /// Create initialization flags from raw integer.
    fn fromU32(flags: u32) Self {
        return .{
            .timer = (flags & C_SDL.SDL_INIT_TIMER) != 0,
            .audio = (flags & C_SDL.SDL_INIT_AUDIO) != 0,
            .video = (flags & C_SDL.SDL_INIT_VIDEO) != 0,
            .joystick = (flags & C_SDL.SDL_INIT_JOYSTICK) != 0,
            .haptic = (flags & C_SDL.SDL_INIT_HAPTIC) != 0,
            .gamepad = (flags & C_SDL.SDL_INIT_GAMEPAD) != 0,
            .events = (flags & C_SDL.SDL_INIT_EVENTS) != 0,
            .sensor = (flags & C_SDL.SDL_INIT_SENSOR) != 0,
            .camera = (flags & C_SDL.SDL_INIT_CAMERA) != 0,
        };
    }

    /// Convert initialization flags into a raw integer.
    fn asU32(self: Self) u32 {
        return (if (self.timer) @as(u32, C_SDL.SDL_INIT_TIMER) else 0) |
            (if (self.audio) @as(u32, C_SDL.SDL_INIT_AUDIO) else 0) |
            (if (self.video) @as(u32, C_SDL.SDL_INIT_VIDEO) else 0) |
            (if (self.joystick) @as(u32, C_SDL.SDL_INIT_JOYSTICK) else 0) |
            (if (self.haptic) @as(u32, C_SDL.SDL_INIT_HAPTIC) else 0) |
            (if (self.gamepad) @as(u32, C_SDL.SDL_INIT_GAMEPAD) else 0) |
            (if (self.events) @as(u32, C_SDL.SDL_INIT_EVENTS) else 0) |
            (if (self.sensor) @as(u32, C_SDL.SDL_INIT_SENSOR) else 0) |
            (if (self.camera) @as(u32, C_SDL.SDL_INIT_CAMERA) else 0);
    }
};

/// Initialize the SDL systems. Each system is ref-counted so init and quit each one, then call shutdown.
pub fn init(flags: Flags) !void {
    if (!C_SDL.SDL_Init(flags.asU32()))
        return error.SDLError;
}

/// Quit SDL systems. Note that shutdown is still needed after all systems have been quit.
pub fn quit(flags: Flags) void {
    C_SDL.SDL_QuitSubSystem(flags.asU32());
}

/// Shutdown SDL. This is needed. Each system is ref-counted so init and quit each one, then call this.
pub fn shutdown() void {
    C_SDL.SDL_Quit();
}

/// Get which given systems have been initialized.
pub fn wasInit(flags: Flags) Flags {
    return Flags.fromU32(C_SDL.SDL_WasInit(flags.asU32()));
}

/// Set program metadata. Encouraged to do this before init. Passing null for a field will clear it.
pub fn setAppMetadata(app_name: ?[:0]const u8, app_version: ?[:0]const u8, app_identifier: ?[:0]const u8) !void {
    var name: [*c]const u8 = 0;
    var version: [*c]const u8 = 0;
    var identifier: [*c]const u8 = 0;
    if (app_name) |item| {
        name = item.ptr;
    }
    if (app_version) |item| {
        version = item.ptr;
    }
    if (app_identifier) |item| {
        identifier = item.ptr;
    }
    if (!C_SDL.SDL_SetAppMetadata(name, version, identifier))
        return error.SDLError;
}

/// Metadata property.
pub const AppMetadataProperty = enum {
    Name,
    Version,
    Identifier,
    Creator,
    Copyright,
    Url,
    Type,
};

/// Set a metadata property for the app. Note that the value can be null to clear it.
pub fn setAppMetadataProperty(property: AppMetadataProperty, value: ?[:0]const u8) !void {
    var val: [*c]const u8 = 0;
    if (value) |item| {
        val = item.ptr;
    }
    if (!C_SDL.SDL_SetAppMetadataProperty(switch (property) {
        .Name => C_SDL.SDL_PROP_APP_METADATA_NAME_STRING,
        .Version => C_SDL.SDL_PROP_APP_METADATA_VERSION_STRING,
        .Identifier => C_SDL.SDL_PROP_APP_METADATA_IDENTIFIER_STRING,
        .Creator => C_SDL.SDL_PROP_APP_METADATA_CREATOR_STRING,
        .Copyright => C_SDL.SDL_PROP_APP_METADATA_COPYRIGHT_STRING,
        .Url => C_SDL.SDL_PROP_APP_METADATA_URL_STRING,
        .Type => C_SDL.SDL_PROP_APP_METADATA_TYPE_STRING,
    }, val))
        return error.SDLError;
}

/// Get a metadata property for the app.
pub fn getAppMetadataProperty(property: AppMetadataProperty) ?[]const u8 {
    const res = C_SDL.SDL_GetAppMetadataProperty(switch (property) {
        .Name => C_SDL.SDL_PROP_APP_METADATA_NAME_STRING,
        .Version => C_SDL.SDL_PROP_APP_METADATA_VERSION_STRING,
        .Identifier => C_SDL.SDL_PROP_APP_METADATA_IDENTIFIER_STRING,
        .Creator => C_SDL.SDL_PROP_APP_METADATA_CREATOR_STRING,
        .Copyright => C_SDL.SDL_PROP_APP_METADATA_COPYRIGHT_STRING,
        .Url => C_SDL.SDL_PROP_APP_METADATA_URL_STRING,
        .Type => C_SDL.SDL_PROP_APP_METADATA_TYPE_STRING,
    });
    if (res == null)
        return null;
    return std.mem.span(res);
}

test "Init" {
    defer shutdown();
    const flags = Flags{
        .video = true,
        .events = true,
        .camera = true,
    };
    try setAppMetadata("SDL3 Test", null, "#Testing");
    try init(flags);
    defer quit(flags);
    try std.testing.expect(std.meta.eql(flags, wasInit(flags)));
    try std.testing.expect(std.mem.eql(u8, getAppMetadataProperty(.Name).?, "SDL3 Test"));
    try std.testing.expect(getAppMetadataProperty(.Version) == null);
    try std.testing.expect(std.mem.eql(u8, getAppMetadataProperty(.Identifier).?, "#Testing"));
    try setAppMetadataProperty(.Creator, "Gota7");
    try std.testing.expect(std.mem.eql(u8, getAppMetadataProperty(.Creator).?, "Gota7"));
    try setAppMetadataProperty(.Creator, null);
    try std.testing.expect(getAppMetadataProperty(.Creator) == null);
    try std.testing.expect(getAppMetadataProperty(.Url) == null);
}
