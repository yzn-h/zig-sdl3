const C_SDL = @import("c_sdl.zig").C_SDL;
const Error = @import("error.zig").Error;
const Window = @import("video.zig").Window;
const std = @import("std");

/// Message box flags.
pub const Flags = struct {
    const Self = @This();
    error_dialog: bool = false,
    warning_dialog: bool = false,
    information_dialog: bool = false,
    buttons_left_to_right: bool = false,
    buttons_right_to_left: bool = false,

    /// Convert message box flags to a raw integer.
    fn asU32(self: Self) u32 {
        return (if (self.error_dialog) @as(u32, C_SDL.SDL_MESSAGEBOX_ERROR) else 0) |
            (if (self.warning_dialog) @as(u32, C_SDL.SDL_MESSAGEBOX_WARNING) else 0) |
            (if (self.information_dialog) @as(u32, C_SDL.SDL_MESSAGEBOX_INFORMATION) else 0) |
            (if (self.buttons_left_to_right) @as(u32, C_SDL.SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT) else 0) |
            (if (self.buttons_right_to_left) @as(u32, C_SDL.SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT) else 0);
    }
};

// Message box button.
pub const Button = struct {
    mark_default_with_return_key: bool = false,
    mark_default_with_escape_key: bool = false,
    value: i32,
    text: [:0]const u8,

    /// Convert into an SDL button.
    fn toSDL(self: Button) C_SDL.SDL_MessageBoxButtonData {
        return .{
            .flags = (if (self.mark_default_with_return_key) C_SDL.SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT else 0) |
                (if (self.mark_default_with_escape_key) C_SDL.SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT else 0),
            .buttonID = @intCast(self.value),
            .text = self.text,
        };
    }
};

/// Message box color. Simple RGB.
pub const Color = struct {
    const Self = @This();
    r: u8,
    g: u8,
    b: u8,

    /// Initialize a color from RGB sequence.
    pub fn init(r: u8, g: u8, b: u8) Self {
        return .{ .r = r, .g = g, .b = b };
    }

    /// Create a color from a hex code.
    pub fn fromHex(hex_code: *const [6:0]u8) !Self {
        return .{
            .r = try std.fmt.parseInt(u8, hex_code[0..2], 16),
            .g = try std.fmt.parseInt(u8, hex_code[2..4], 16),
            .b = try std.fmt.parseInt(u8, hex_code[4..6], 16),
        };
    }

    /// Convert into an SDL color.
    fn toSDL(self: Self) C_SDL.SDL_MessageBoxColor {
        return .{
            .r = self.r,
            .g = self.g,
            .b = self.b,
        };
    }
};

/// Message box colors.
pub const Colors = struct {
    background: Color,
    text: Color,
    button_border: Color,
    button_background: Color,
    button_selected: Color,

    /// Convert to an SDL color scheme.
    fn toSDL(self: Colors) C_SDL.SDL_MessageBoxColorScheme {
        return .{ .colors = .{ self.background.toSDL(), self.text.toSDL(), self.button_border.toSDL(), self.button_background.toSDL(), self.button_selected.toSDL() } };
    }
};

/// Message box data.
pub const Data = struct {
    flags: Flags,
    parent_window: ?Window,
    title: [:0]const u8,
    message: [:0]const u8,
    buttons: []const Button,
    colors: ?Colors,
};

/// Show a message box with more advanced data.
pub fn show(allocator: std.mem.Allocator, data: Data) !i32 {
    var buttons = try allocator.alloc(C_SDL.SDL_MessageBoxButtonData, @intCast(data.buttons.len));
    defer allocator.free(buttons);
    for (0..data.buttons.len) |ind| {
        buttons[ind] = data.buttons[ind].toSDL();
    }
    var colors: C_SDL.SDL_MessageBoxColorScheme = undefined;
    if (data.colors) |val| {
        colors = val.toSDL();
    }
    const msg_data = C_SDL.SDL_MessageBoxData{
        .flags = data.flags.asU32(),
        .window = if (data.parent_window) |val| val.handle else null,
        .title = data.title,
        .message = data.message,
        .numbuttons = @intCast(data.buttons.len),
        .buttons = buttons.ptr,
        .colorScheme = if (data.colors != null) &colors else null,
    };
    var button_id: c_int = undefined;
    if (!C_SDL.SDL_ShowMessageBox(&msg_data, &button_id))
        return error.SDLError;
    return @intCast(button_id);
}

/// Show a simple message box.
pub fn showSimple(flags: Flags, title: [:0]const u8, message: [:0]const u8, parent_window: ?Window) !void {
    if (!C_SDL.SDL_ShowSimpleMessageBox(flags.asU32(), title, message, if (parent_window) |val| val.handle else null))
        return error.SDLError;
}
