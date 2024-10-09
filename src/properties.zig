// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Properties type enum.
pub const Type = enum(c_uint) {
	Invalid = C.SDL_PROPERTY_TYPE_INVALID,
	Pointer = C.SDL_PROPERTY_TYPE_POINTER,
	String = C.SDL_PROPERTY_TYPE_STRING,
	Number = C.SDL_PROPERTY_TYPE_NUMBER,
	Float = C.SDL_PROPERTY_TYPE_FLOAT,
	Boolean = C.SDL_PROPERTY_TYPE_BOOLEAN,
};

/// SDL properties group. Properties can be added or removed at runtime.
pub const Group = struct {
	value: C.SDL_PropertiesID,

	/// Copy and replace all properties in destination with ones in this one. Will not copy properties that require cleanup.
	pub fn copyTo(
		self: Group,
		dest: Group,
	) !void {
		const ret = C.SDL_CopyProperties(
			self.value,
			dest.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Destroy the group of properties.
	pub fn deinit(
		self: Group,
	) void {
		const ret = C.SDL_DestroyProperties(
			self.value,
		);
		_ = ret;
	}
};
