// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// A 128-bit identifier for an input device that identifies that device across runs of SDL programs on the same platform.
pub const GUID = struct {
	value: C.SDL_GUID,

	/// Get an ASCII string representation for a given SDL_GUID. Returned memory must be freed.
	pub fn toString(
		self: GUID,
		str: [32:0]u8,
	) void {
		const ret = C.SDL_GUIDToString(
			self.value,
			str.ptr,
			@intCast(str.len),
		);
		_ = ret;
	}

	/// Convert a GUID string into a SDL_GUID structure. TODO, Determine if this copies properly!
	pub fn fromString(
		buf: [:0]const u8,
	) GUID {
		const ret = C.SDL_StringToGUID(
			buf,
		);
		return GUID{ .value = ret };
	}
};
