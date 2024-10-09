const C_SDL = @import("c_sdl.zig").C_SDL;
const std = @import("std");

/// Set the current SDL error.
pub fn set(err: [*:0]const u8) void {
    _ = C_SDL.SDL_SetError("%s", err);
}

/// Set an error indicating that memory allocation failed.
pub fn signalOutOfMemory() void {
    _ = C_SDL.SDL_OutOfMemory();
}

/// Get the last error message if it exists. Note that lack of an error does not indicate succees, and an error being present does not indicate failure.
pub fn get() ?[]const u8 {
    const err = std.mem.span(C_SDL.SDL_GetError());
    if (std.mem.eql(u8, err, "")) {
        return null;
    }
    return err;
}

/// Clear the last error message.
pub fn clear() void {
    _ = C_SDL.SDL_ClearError();
}

/// An SDL error.
pub const Error = error{
    SDLError,
};

test "Error" {
    clear();
    try std.testing.expect(get() == null);
    signalOutOfMemory();
    try std.testing.expect(std.mem.eql(u8, get().?, "Out of memory"));
    set("Hello world");
    try std.testing.expect(std.mem.eql(u8, get().?, "Hello world"));
    clear();
    try std.testing.expect(get() == null);
}
