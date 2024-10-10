// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// An SDL error.
pub const Error = error{
	SdlError,
};

/// Set the current SDL error.
pub fn set(
	err: [:0]const u8,
) void {
	const ret = C.SDL_SetError(
		"%s",
		err.ptr,
	);
	_ = ret;
}

/// Set an error indicating that memory allocation failed.
pub fn signalOutOfMemory() void {
	const ret = C.SDL_OutOfMemory();
	_ = ret;
}

/// Get the last error message if it exists. Note that lack of an error does not indicate succees, and an error being present does not indicate failure.
pub fn get() ?[]const u8 {
	const ret = C.SDL_GetError();
	const converted_ret = std.mem.span(ret);
	if (std.mem.eql(u8, converted_ret, ""))
		return null;
	return converted_ret;
}

/// Clear the last error message.
pub fn clear() void {
	const ret = C.SDL_ClearError();
	_ = ret;
}

// Make sure error getting and setting works properly.
test "Error" {
	clear();
	try std.testing.expect(get() == null);
	signalOutOfMemory();
	try std.testing.expect(std.mem.eql(u8, get().?, "Out of memory"));
	set("Hello world");
	try std.testing.expect(std.mem.eql(u8, get().?, "Hello world"));
	clear();
	try std.testing.expect(get() == null);
}
