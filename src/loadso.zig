// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// A shared object binary.
pub const SharedObject = struct {
	value: *C.SDL_SharedObject,

	/// Load a shared object.
	pub fn load(
		name: [:0]const u8,
	) !SharedObject {
		const ret = C.SDL_LoadObject(
			name,
		);
		if (ret == null)
			return error.SdlError;
		return SharedObject{ .value = ret.? };
	}

	/// Get a function pointer to an exported function in the object file.
	pub fn loadFunction(
		self: SharedObject,
		name: [:0]const u8,
	) ?*anyopaque {
		const ret = C.SDL_LoadFunction(
			self.value,
			name,
		);
		return ret;
	}

	/// Unload the shared object.
	pub fn unload(
		self: SharedObject,
	) void {
		const ret = C.SDL_UnloadObject(
			self.value,
		);
		_ = ret;
	}
};
