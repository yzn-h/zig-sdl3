const C_SDL = @import("c_sdl.zig").C_SDL;

/// Opaque handle for a window.
pub const WindowHandle = C_SDL.SDL_Window;

/// Window.
pub const Window = struct {
    handle: *WindowHandle,
};
