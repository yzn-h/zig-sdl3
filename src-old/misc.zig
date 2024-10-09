const C_SDL = @import("c_sdl.zig").C_SDL;
const Error = @import("error.zig").Error;

/// Open a URL in the browser of the platform. Can also do local files with `file:///path/to/file` if supported.
pub fn openURL(url: [:0]const u8) !void {
    if (!C_SDL.SDL_OpenURL(url))
        return error.SDLError;
}
