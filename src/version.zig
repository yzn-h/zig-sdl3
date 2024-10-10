// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// SDL version information.
pub const Version = struct {
	value: c_int,
	/// SDL version compiled against.
	pub const compiled_against = Version{ .value = C.SDL_VERSION };

	/// Create an SDL version number.
	pub fn make(
		major: u32,
		minor: u32,
		micro: u32,
	) Version {
		const ret = C.SDL_VERSIONNUM(
			@intCast(major),
			@intCast(minor),
			@intCast(micro),
		);
		return Version{ .value = ret };
	}

	/// Major version number.
	pub fn getMajor(
		self: Version,
	) u32 {
		const ret = C.SDL_VERSIONNUM_MAJOR(
			self.value,
		);
		return @intCast(ret);
	}

	/// Minor version number.
	pub fn getMinor(
		self: Version,
	) u32 {
		const ret = C.SDL_VERSIONNUM_MINOR(
			self.value,
		);
		return @intCast(ret);
	}

	/// Micro version number.
	pub fn getMicro(
		self: Version,
	) u32 {
		const ret = C.SDL_VERSIONNUM_MICRO(
			self.value,
		);
		return @intCast(ret);
	}

	/// Check if the SDL version is at least greater than the given one.
	pub fn atLeast(
		major: u32,
		minor: u32,
		micro: u32,
	) bool {
		const ret = C.SDL_VERSION_ATLEAST(
			@intCast(major),
			@intCast(minor),
			@intCast(micro),
		);
		return ret;
	}

	/// Get the version of SDL that is linked against your program. Possibly different than the compiled against version.
	pub fn get() Version {
		const ret = C.SDL_GetVersion();
		return Version{ .value = ret };
	}

	/// Get the code revision of SDL that is linked against your program.
	pub fn getRevision() ?[]const u8 {
		const ret = C.SDL_GetRevision();
		const converted_ret = std.mem.span(ret);
		if (std.mem.eql(u8, converted_ret, ""))
			return null;
		return converted_ret;
	}
};
