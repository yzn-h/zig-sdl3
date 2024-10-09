// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Open a URL in the browser of the platform. Can also do local files with `file:///path/to/file` if supported.
pub fn openURL(
	url: [:0]const u8,
) !void {
	const ret = C.SDL_OpenURL(
		url,
	);
	if (!ret)
		return error.SdlError;
}
