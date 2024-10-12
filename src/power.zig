// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// The basic state for the system's power supply.
pub const PowerState = enum(c_int) {
	/// Can not determine power status.
	Unknown = C.SDL_POWERSTATE_UNKNOWN,
	/// Not plugged in, running on battery.
	OnBattery = C.SDL_POWERSTATE_ON_BATTERY,
	/// Plugged in, no battery available.
	NoBattery = C.SDL_POWERSTATE_NO_BATTERY,
	/// Plugged in, battery charging.
	Charging = C.SDL_POWERSTATE_CHARGING,
	/// Plugged in, battery charged.
	Charged = C.SDL_POWERSTATE_CHARGED,

	/// Get the current power supply details.
	pub fn get() !struct { state: PowerState, seconds_left: ?u32, percent: ?u7 } {
		var seconds_left: c_int = undefined;
		var percent: c_int = undefined;
		const ret = C.SDL_GetPowerInfo(
			&seconds_left,
			&percent,
		);
		if (ret == C.SDL_POWERSTATE_ERROR)
			return error.SdlError;
		return .{ .state = ret, .seconds_left = if (seconds_left == -1) null else @intCast(seconds_left), .percent = if (percent == -1) null else @intCast(percent) };
	}
};
