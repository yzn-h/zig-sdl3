// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// System theme.
pub const SystemTheme = enum(c_uint) {
	Light = C.SDL_SYSTEM_THEME_LIGHT,
	Dark = C.SDL_SYSTEM_THEME_DARK,
};

/// Display orientation values; the way a display is rotated.
pub const DisplayOrientation = enum(c_uint) {
	/// The display is in landscape mode, with the right side up, relative to portrait mode.
	Landscape = C.SDL_ORIENTATION_LANDSCAPE,
	/// The display is in landscape mode, with the left side up, relative to portrait mode.
	LandscapeFlipped = C.SDL_ORIENTATION_LANDSCAPE_FLIPPED,
	/// The display is in portrait mode.
	Portrait = C.SDL_ORIENTATION_PORTRAIT,
	/// The display is in portrait mode, upside down.
	PortraitFlipped = C.SDL_ORIENTATION_PORTRAIT_FLIPPED,
};

/// A display.
pub const Display = struct {
	value: C.SDL_DisplayID,

	/// Return the primary display.
	pub fn getPrimaryDisplay() !Display {
		const ret = C.SDL_GetPrimaryDisplay();
		if (ret == 0)
			return error.SdlError;
		return Display{ .value = ret };
	}

	/// Get the name of a display in UTF-8 encoding.
	pub fn getName(
		self: Display,
	) ![]const u8 {
		const ret = C.SDL_GetDisplayName(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return std.mem.span(ret);
	}

	/// Get the desktop area represented by a display.
	pub fn getBounds(
		self: Display,
	) !rect.IRect {
		var area: C.SDL_Rect = undefined;
		const ret = C.SDL_GetDisplayBounds(
			self.value,
			&area,
		);
		if (!ret)
			return error.SdlError;
		return ret.fromSdl();
	}

	/// Get the usable desktop area represented by a display, in screen coordinates.
	pub fn getUsableBounds(
		self: Display,
	) !rect.IRect {
		var area: C.SDL_Rect = undefined;
		const ret = C.SDL_GetDisplayUsableBounds(
			self.value,
			&area,
		);
		if (!ret)
			return error.SdlError;
		return ret.fromSdl();
	}

	/// Get the orientation of a display when it is unrotated.
	pub fn getNaturalOrientation(
		self: Display,
	) ?DisplayOrientation {
		const ret = C.SDL_GetNaturalDisplayOrientation(
			self.value,
		);
		if (ret == C.SDL_ORIENTATION_UNKNOWN)
			return null;
		return @enumFromInt(ret);
	}

	/// Get the orientation of a display.
	pub fn getCurrentOrientation(
		self: Display,
	) ?DisplayOrientation {
		const ret = C.SDL_GetCurrentDisplayOrientation(
			self.value,
		);
		if (ret == C.SDL_ORIENTATION_UNKNOWN)
			return null;
		return @enumFromInt(ret);
	}

	/// Get the content scale of a display.
	pub fn getContentScale(
		self: Display,
	) !f32 {
		const ret = C.SDL_GetDisplayContentScale(
			self.value,
		);
		if (ret == 0.0)
			return error.SdlError;
		return @floatCast(ret);
	}

	/// Get a list of currently connected displays.
    pub fn getAll(allocator: std.mem.Allocator) ![]Display {
        var count: c_int = undefined;
        const ret = C.SDL_GetDisplays(&count);
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        const converted_ret = try allocator.alloc(Display, @intCast(count));
        for (0..count) |index| {
            converted_ret[index].value = ret[index];
        }
        return converted_ret;
    }
};

/// Create a window with the specified dimensions and flags.
pub const Window = struct {
	value: *C.SDL_Window,

	/// Create a window with the specified dimensions and flags.
	pub fn init(
		title: [:0]const u8,
		width: u32,
		height: u32,
		flags: WindowFlags,
	) !Window {
		const ret = C.SDL_CreateWindow(
			title,
			@intCast(width),
			@intCast(height),
			flags.toSdl(),
		);
		if (ret == null)
			return error.SdlError;
		return Window{ .value = ret.? };
	}

	/// Get the SDL surface associated with the window.
	pub fn getSurface(
		self: Window,
	) !surface.Surface {
		const ret = C.SDL_GetWindowSurface(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return surface.Surface{ .value = ret };
	}

	/// Copy the window surface to the screen.
	pub fn updateSurface(
		self: Window,
	) !void {
		const ret = C.SDL_UpdateWindowSurface(
			self.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Confines the cursor to the specified area of a window.
	pub fn setMouseRect(
		self: Window,
		area: ?rect.IRect,
	) !void {
		const area_sdl: ?C.SDL_Rect = if (area == null) null else area.?.toSdl();
		const ret = C.SDL_SetWindowMouseRect(
			self.value,
			if (area_sdl == null) null else &(area_sdl.?),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Destroy a window.
	pub fn deinit(
		self: Window,
	) void {
		const ret = C.SDL_DestroyWindow(
			self.value,
		);
		_ = ret;
	}
};

/// The flags on a window.
pub const WindowFlags = struct {
	/// Window is in fullscreen mode.
	Fullscreen: bool = false,
	/// Window usable with OpenGL context.
	OpenGL: bool = false,
	/// Window is occluded.
	Occluded: bool = false,
	/// Window is neither mapped onto the desktop nor shown in the taskbar/dock/window list. The `show` function must be called for the window.
	Hidden: bool = false,
	/// No window decoration.
	Borderless: bool = false,

	/// Convert from an SDL value.
	pub fn fromSdl(flags: C.SDL_WindowFlags) WindowFlags {
		return .{
			.Fullscreen = (flags & C.SDL_WINDOW_FULLSCREEN) != 0,
			.OpenGL = (flags & C.SDL_WINDOW_OPENGL) != 0,
			.Occluded = (flags & C.SDL_WINDOW_OCCLUDED) != 0,
			.Hidden = (flags & C.SDL_WINDOW_HIDDEN) != 0,
			.Borderless = (flags & C.SDL_WINDOW_BORDERLESS) != 0,
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: WindowFlags) C.SDL_WindowFlags {
		return (if (self.Fullscreen) @as(C.SDL_WindowFlags, C.SDL_WINDOW_FULLSCREEN) else 0) |
			(if (self.OpenGL) @as(C.SDL_WindowFlags, C.SDL_WINDOW_OPENGL) else 0) |
			(if (self.Occluded) @as(C.SDL_WindowFlags, C.SDL_WINDOW_OCCLUDED) else 0) |
			(if (self.Hidden) @as(C.SDL_WindowFlags, C.SDL_WINDOW_HIDDEN) else 0) |
			(if (self.Borderless) @as(C.SDL_WindowFlags, C.SDL_WINDOW_BORDERLESS) else 0) |
			0;
	}
};

/// Get the number of video drivers compiled into SDL.
pub fn getNumDrivers() u31 {
	const ret = C.SDL_GetNumVideoDrivers();
	return @intCast(ret);
}

/// Get the name of a built in video driver.
pub fn getDriverName(
	index: u31,
) ?[]const u8 {
	const ret = C.SDL_GetVideoDriver(
		@intCast(index),
	);
	if (ret == null)
		return null;
	return std.mem.span(ret);
}

/// Get the name of the currently initialized video driver.
pub fn getCurrentDriverName() ?[]const u8 {
	const ret = C.SDL_GetCurrentVideoDriver();
	if (ret == null)
		return null;
	return std.mem.span(ret);
}

/// Get the current system theme.
pub fn getSystemTheme() ?SystemTheme {
	const ret = C.SDL_GetSystemTheme();
	if (ret == C.SDL_SYSTEM_THEME_UNKNOWN)
		return null;
	return @enumFromInt(ret);
}

const rect = @import("rect.zig");
const surface = @import("surface.zig");
