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
	flags: BoxFlags,
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
			.buttonID = @intCast(self.buttonID),
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
