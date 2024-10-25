// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Message box button flags.
pub const ButtonFlags = struct {
	mark_default_with_return_key: bool = false,
	mark_default_with_escape_key: bool = false,

	/// Convert from an SDL value.
	pub fn fromSdl(flags: C.SDL_MessageBoxButtonFlags) ButtonFlags {
		return .{
			.mark_default_with_return_key = (flags & C.SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT) != 0,
			.mark_default_with_escape_key = (flags & C.SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT) != 0,
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: ButtonFlags) C.SDL_MessageBoxButtonFlags {
		return (if (self.mark_default_with_return_key) @as(C.SDL_MessageBoxButtonFlags, C.SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT) else 0) |
			(if (self.mark_default_with_escape_key) @as(C.SDL_MessageBoxButtonFlags, C.SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT) else 0) |
			0;
	}
};

/// Message box flags.
pub const BoxFlags = struct {
	error_dialog: bool = false,
	warning_dialog: bool = false,
	information_dialog: bool = false,
	buttons_left_to_right: bool = false,
	buttons_right_to_left: bool = false,

	/// Convert from an SDL value.
	pub fn fromSdl(flags: C.SDL_MessageBoxFlags) BoxFlags {
		return .{
			.error_dialog = (flags & C.SDL_MESSAGEBOX_ERROR) != 0,
			.warning_dialog = (flags & C.SDL_MESSAGEBOX_WARNING) != 0,
			.information_dialog = (flags & C.SDL_MESSAGEBOX_INFORMATION) != 0,
			.buttons_left_to_right = (flags & C.SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT) != 0,
			.buttons_right_to_left = (flags & C.SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT) != 0,
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: BoxFlags) C.SDL_MessageBoxFlags {
		return (if (self.error_dialog) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_ERROR) else 0) |
			(if (self.warning_dialog) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_WARNING) else 0) |
			(if (self.information_dialog) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_INFORMATION) else 0) |
			(if (self.buttons_left_to_right) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT) else 0) |
			(if (self.buttons_right_to_left) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT) else 0) |
			0;
	}
};

/// Message box button.
pub const Button = struct {
	flags: BoxFlags = .{},
	value: i32,
	text: [:0]const u8,

	/// Convert from an SDL value.
	pub fn fromSdl(data: C.SDL_MessageBoxButtonData) Button {
		return .{
			.flags = BoxFlags.fromSdl(data.flags),
			.value = @intCast(data.buttonID),
			.text = std.mem.span(data.text),
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: Button) C.SDL_MessageBoxButtonData {
		return .{
			.flags = self.flags.toSdl(),
			.buttonID = @intCast(self.value),
			.text = self.text,
		};
	}
};

/// Message box color. Simple RGB.
pub const Color = struct {
	r: u8,
	g: u8,
	b: u8,

	/// Convert from an SDL value.
	pub fn fromSdl(data: C.SDL_MessageBoxColor) Color {
		return .{
			.r = @intCast(data.r),
			.g = @intCast(data.g),
			.b = @intCast(data.b),
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: Color) C.SDL_MessageBoxColor {
		return .{
			.r = @intCast(self.r),
			.g = @intCast(self.g),
			.b = @intCast(self.b),
		};
	}

	/// Create a color from a hex code.
    pub fn fromHex(hex_code: *const [6:0]u8) !Color {
        return .{
            .r = try std.fmt.parseInt(u8, hex_code[0..2], 16),
            .g = try std.fmt.parseInt(u8, hex_code[2..4], 16),
            .b = try std.fmt.parseInt(u8, hex_code[4..6], 16),
        };
    }
};

/// Display a simple modal message box.
pub fn showSimple(
	flags: BoxFlags,
	title: [:0]const u8,
	message: [:0]const u8,
	parent_window: ?video.Window,
) !void {
	const ret = C.SDL_ShowSimpleMessageBox(
		flags.toSdl(),
		title,
		message,
		if (parent_window) |parent_window_val| parent_window_val.value else null,
	);
	if (!ret)
		return error.SdlError;
}

/// A set of colors to use for message box dialogs.
pub const ColorScheme = struct {
    background: Color,
    text: Color,
    button_border: Color,
    button_background: Color,
    button_selected: Color,
    /// Convert from an SDL value.
    pub fn fromSdl(data: C.SDL_MessageBoxColorScheme) ColorScheme {
        return .{
            .background = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_BACKGROUND]),
            .text = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_TEXT]),
            .button_border = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_BORDER]),
            .button_background = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND]),
            .button_selected = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED]),
        };
    }
    /// Convert to an SDL value.
    pub fn toSdl(self: ColorScheme) C.SDL_MessageBoxColorScheme {
        var ret: C.SDL_MessageBoxColorScheme = undefined;
        ret.colors[C.SDL_MESSAGEBOX_COLOR_BACKGROUND] = self.background.toSdl();
        ret.colors[C.SDL_MESSAGEBOX_COLOR_TEXT] = self.text.toSdl();
        ret.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_BORDER] = self.button_border.toSdl();
        ret.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND] = self.button_background.toSdl();
        ret.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED] = self.button_selected.toSdl();
        return ret;
    }
};

/// Buttons.
pub fn Buttons(comptime len: usize) type {
    return struct {
        buttons: [len]C.SDL_MessageBoxButtonData,
        /// Create buttons from zig.
        pub fn fromZig(buttons: [len]Button) Buttons(len) {
            var ret: Buttons(len) = undefined;
            for (0..len) |ind| {
                ret.buttons[ind] = buttons[ind].toSdl();
            }
            return ret;
        }
    };
}

/// Create a modal message box.
pub fn show(
    flags: BoxFlags,
    title: [:0]const u8,
    message: [:0]const u8,
    parent_window: ?video.Window,
    comptime buttons: anytype,
    color_scheme: ?ColorScheme,
) !u32 {
    const button_data = Buttons(buttons.len).fromZig(buttons);
    const colors: ?C.SDL_MessageBoxColorScheme = if (color_scheme) |val| val.toSdl() else null;
    const data = C.SDL_MessageBoxData{
        .buttons = &button_data.buttons,
        .colorScheme = if (color_scheme) |_| &colors.? else null,
        .flags = flags.toSdl(),
        .message = message,
        .numbuttons = @intCast(buttons.len),
        .title = title,
        .window = if (parent_window == null) null else parent_window.?.value,
    };
    var button_id: c_int = undefined;
    const ret = C.SDL_ShowMessageBox(&data, &button_id);
    if (!ret)
        return error.SdlError;
    return @intCast(button_id);
}

/// Create a modal message box.
pub fn showWithButtonLen(
    flags: BoxFlags,
    title: [:0]const u8,
    message: [:0]const u8,
    parent_window: ?video.Window,
    comptime buttons_len: usize,
    buttons: Buttons(buttons_len),
    color_scheme: ?ColorScheme,
) !u32 {
    const colors: ?C.SDL_MessageBoxColorScheme = if (color_scheme) |val| val.toSdl() else null;
    const data = C.SDL_MessageBoxData{
        .buttons = &buttons.buttons,
        .colorScheme = if (color_scheme) |_| &colors.? else null,
        .flags = flags.toSdl(),
        .message = message,
        .numbuttons = @intCast(buttons_len),
        .title = title,
        .window = if (parent_window == null) null else parent_window.?.value,
    };
    var button_id: c_int = undefined;
    const ret = C.SDL_ShowMessageBox(&data, &button_id);
    if (!ret)
        return error.SdlError;
    return @intCast(button_id);
}

const video = @import("video.zig");
