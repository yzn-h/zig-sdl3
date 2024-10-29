// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// An enum of some common joystick types.
pub const Type = enum(c_uint) {
	Gamepad = C.SDL_JOYSTICK_TYPE_GAMEPAD,
	Wheel = C.SDL_JOYSTICK_TYPE_WHEEL,
	ArcadeStick = C.SDL_JOYSTICK_TYPE_ARCADE_STICK,
	FlightStick = C.SDL_JOYSTICK_TYPE_FLIGHT_STICK,
	DancePad = C.SDL_JOYSTICK_TYPE_DANCE_PAD,
	Guitar = C.SDL_JOYSTICK_TYPE_GUITAR,
	DrumKit = C.SDL_JOYSTICK_TYPE_DRUM_KIT,
	ArcadePad = C.SDL_JOYSTICK_TYPE_ARCADE_PAD,
	Throttle = C.SDL_JOYSTICK_TYPE_THROTTLE,
};

/// Possible connection states for a joystick device.
pub const ConnectionState = enum(c_int) {
	Wired = C.SDL_JOYSTICK_CONNECTION_WIRED,
	Wireless = C.SDL_JOYSTICK_CONNECTION_WIRELESS,
};

/// This is a unique ID for a joystick for the time it is connected to the system, and is never reused for the lifetime of the application.
pub const ID = struct {
	value: C.SDL_JoystickID,

	/// Get the implementation dependent name of a joystick.
	pub fn getName(
		self: ID,
	) []const u8 {
		const ret = C.SDL_GetJoystickNameForID(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return std.mem.span(ret);
	}

	/// Get the implementation dependent path of a joystick.
	pub fn getPath(
		self: ID,
	) []const u8 {
		const ret = C.SDL_GetJoystickPathForID(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return std.mem.span(ret);
	}

	/// Get the player index of a joystick.
	pub fn getPlayerIndex(
		self: ID,
	) ?u31 {
		const ret = C.SDL_GetJoystickPlayerIndexForID(
			self.value,
		);
		if (ret == -1)
			return null;
		return @intCast(ret);
	}

	/// Get the implementation-dependent GUID of a joystick.
	pub fn getGUID(
		self: ID,
	) guid.GUID {
		const ret = C.SDL_GetJoystickGUIDForID(
			self.value,
		);
		return guid.GUID{ .value = ret };
	}

	/// Get the USB vendor ID of a joystick, if available.
	pub fn getVendor(
		self: ID,
	) u16 {
		const ret = C.SDL_GetJoystickVendorForID(
			self.value,
		);
		return @intCast(ret);
	}

	/// Get the USB product ID of a joystick, if available.
	pub fn getProduct(
		self: ID,
	) u16 {
		const ret = C.SDL_GetJoystickProductForID(
			self.value,
		);
		return @intCast(ret);
	}

	/// Get the product version of a joystick, if available.
	pub fn getProductVersion(
		self: ID,
	) u16 {
		const ret = C.SDL_GetJoystickProductVersionForID(
			self.value,
		);
		return @intCast(ret);
	}

	/// Get the type of a joystick, if available.
	pub fn getType(
		self: ID,
	) ?Type {
		const ret = C.SDL_GetJoystickTypeForID(
			self.value,
		);
		if (ret == C.SDL_JOYSTICK_TYPE_UNKNOWN)
			return null;
		return @enumFromInt(ret);
	}

	/// Get the SDL_Joystick associated with an instance ID, if it has been opened.
	pub fn getJoystick(
		self: ID,
	) Joystick {
		const ret = C.SDL_GetJoystickFromID(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return Joystick{ .value = ret.? };
	}

	/// Get a list of currently connected joysticks.
    pub fn getAll(allocator: std.mem.Allocator) ![]ID {
        var count: c_int = undefined;
        const ret = C.SDL_GetJoysticks(&count);
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        var converted_ret = try allocator.alloc(ID, @intCast(count));
        for (0..count) |ind| {
            converted_ret[ind].value = ret[ind];
        }
        return converted_ret;
    }
};

/// The joystick structure used to identify an SDL joystick.
pub const Joystick = struct {
	value: *C.SDL_Joystick,

	/// Open a joystick for use.
	pub fn init(
		id: ID,
	) Joystick {
		const ret = C.SDL_OpenJoystick(
			id.value,
		);
		if (ret == null)
			return error.SdlError;
		return Joystick{ .value = ret.? };
	}

	/// Get the SDL_Joystick associated with a player index.
	pub fn fromPlayerIndex(
		index: u31,
	) Joystick {
		const ret = C.SDL_GetJoystickFromPlayerIndex(
			@intCast(index),
		);
		if (ret == null)
			return error.SdlError;
		return Joystick{ .value = ret.? };
	}
};

/// Locking for atomic access to the joystick API.
pub fn lockJoysticks() void {
	const ret = C.SDL_LockJoysticks();
	_ = ret;
}

/// Unlocking for atomic access to the joystick API.
pub fn unlockJoysticks() void {
	const ret = C.SDL_UnlockJoysticks();
	_ = ret;
}

/// Return whether a joystick is currently connected.
pub fn hasJoystick() bool {
	const ret = C.SDL_HasJoystick();
	return ret;
}

const guid = @import("guid.zig");
