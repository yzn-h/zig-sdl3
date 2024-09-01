const C_SDL = @import("c_sdl.zig").C_SDL;
const Error = @import("error.zig").Error;
const std = @import("std");

/// Unique ID for a display.
const DisplayID = C_SDL.SDL_DisplayID;

/// Actual display.
pub const Display = struct {
    const Self = @This();
    /// An invalid/null display.
    pub const invalid = Display{ .id = 0 };
    id: DisplayID,

    /// Create a display from an SDL ID.
    fn fromID(id: DisplayID) Display {
        return .{ .id = id };
    }

    /// Get the currently connected displays. Memory returned must be freed.
    pub fn get(allocator: std.mem.Allocator) ![]Display {
        var count: c_int = undefined;
        const list = C_SDL.SDL_GetDisplays(&count);
        if (list == 0)
            return error.SDLError;
        var displays = try allocator.alloc(Display, @intCast(count));
        for (0..@intCast(count)) |ind| {
            displays[ind] = fromID(list[ind]);
        }
        C_SDL.SDL_free(list);
        return displays;
    }

    /// Get the name of the display.
    pub fn name(self: Self) ![]const u8 {
        const val = C_SDL.SDL_GetDisplayName(self.id);
        if (val != 0) {
            return std.mem.span(val);
        }
        return error.SDLError;
    }

    /// Get the primary display.
    pub fn primary() !Display {
        const id = C_SDL.SDL_GetPrimaryDisplay();
        if (id == 0)
            return error.SDLError;
        return fromID(id);
    }
};

/// Unique ID for a window.
const WindowID = C_SDL.SDL_WindowID;

/// Theme of the system in use.
pub const SystemTheme = enum(c_int) {
    Unknown = C_SDL.SDL_SYSTEM_THEME_UNKNOWN,
    Light = C_SDL.SDL_SYSTEM_THEME_LIGHT,
    Dark = C_SDL.SDL_SYSTEM_THEME_DARK,
};

/// Opaque handle for a window.
pub const WindowHandle = C_SDL.SDL_Window;

/// Window.
pub const Window = struct {
    handle: *WindowHandle,
};

/// Get the number of video drivers compiled into SDL.
pub fn numDrivers() usize {
    return @intCast(C_SDL.SDL_GetNumVideoDrivers());
}

/// Get the video driver name at a given index. If the index is invalid, return null.
pub fn driverName(index: usize) ?[]const u8 {
    const val = C_SDL.SDL_GetVideoDriver(@intCast(index));
    if (val != 0) {
        return std.mem.span(val);
    }
    return null;
}

/// Get the name of the current video driver. Null if none have been initialized.
pub fn currentDriverName() ?[]const u8 {
    const val = C_SDL.SDL_GetCurrentVideoDriver();
    if (val != 0) {
        return std.mem.span(val);
    }
    return null;
}

/// Get the theme of the system.
pub fn systemTheme() SystemTheme {
    return @enumFromInt(C_SDL.SDL_GetSystemTheme());
}
