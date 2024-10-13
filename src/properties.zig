// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Properties type enum.
pub const Type = enum(c_uint) {
	Pointer = C.SDL_PROPERTY_TYPE_POINTER,
	String = C.SDL_PROPERTY_TYPE_STRING,
	Number = C.SDL_PROPERTY_TYPE_NUMBER,
	Float = C.SDL_PROPERTY_TYPE_FLOAT,
	Boolean = C.SDL_PROPERTY_TYPE_BOOLEAN,
};

/// SDL properties group. Properties can be added or removed at runtime.
pub const Group = struct {
	value: C.SDL_PropertiesID,

	/// Get the global SDL properties.
	pub fn getGlobal() !Group {
		const ret = C.SDL_GetGlobalProperties();
		if (ret == 0)
			return error.SdlError;
		return Group{ .value = ret };
	}

	/// Create a group of properties.
	pub fn init() !Group {
		const ret = C.SDL_CreateProperties();
		if (ret == 0)
			return error.SdlError;
		return Group{ .value = ret };
	}

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

	/// Lock a group of properties.
	pub fn lock(
		self: Group,
	) !void {
		const ret = C.SDL_LockProperties(
			self.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Unlock a group of properties.
	pub fn unlock(
		self: Group,
	) !void {
		const ret = C.SDL_UnlockProperties(
			self.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set a pointer property in a group of properties with a cleanup function that is called when the property is deleted.
	pub fn setPointerPropertyWithCleanup(
		self: Group,
		ValueType: type,
		UserData: type,
		name: [:0]const u8,
		value: ?*ValueType,
		cb: ?*const fn (user_data: *UserData, value: *ValueType) callconv(.C) void,
		user_data: *UserData,
	) !void {
		const ret = C.SDL_SetPointerPropertyWithCleanup(
			self.value,
			name,
			value,
			if (cb) |val| @ptrCast(val) else null,
			user_data,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set a pointer value property, null for the value will delete it.
	pub fn setPointer(
		self: Group,
		name: [:0]const u8,
		value: *?anyopaque,
	) !void {
		const ret = C.SDL_SetPointerProperty(
			self.value,
			name,
			value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set a string value property, null for the value will delete it.
	pub fn setString(
		self: Group,
		name: [:0]const u8,
		value: [:0]const u8,
	) !void {
		const ret = C.SDL_SetStringProperty(
			self.value,
			name,
			value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set a number value property, null for the value will delete it.
	pub fn setNumber(
		self: Group,
		name: [:0]const u8,
		value: i64,
	) !void {
		const ret = C.SDL_SetNumberProperty(
			self.value,
			name,
			@intCast(value),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set a float value property, null for the value will delete it.
	pub fn setFloat(
		self: Group,
		name: [:0]const u8,
		value: f32,
	) !void {
		const ret = C.SDL_SetFloatProperty(
			self.value,
			name,
			@floatCast(value),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set a boolean value property, null for the value will delete it.
	pub fn setBoolean(
		self: Group,
		name: [:0]const u8,
		value: bool,
	) !void {
		const ret = C.SDL_SetBooleanProperty(
			self.value,
			name,
			value,
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
