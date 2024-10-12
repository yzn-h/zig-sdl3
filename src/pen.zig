// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Pen axis indices.
pub const Axis = enum(c_uint) {
	/// Pen pressure. Unidirectional 0 to 1.0
	Pressure = C.SDL_PEN_AXIS_PRESSURE,
	/// Pen horizontal tilt angle. Bidirectional -90.0 to 90.0 (left-to-right).
	XTilt = C.SDL_PEN_AXIS_XTILT,
	/// Pen vertical tilt angle. Bidirectional -90.0 to 90.0 (top-to-down).
	YTilt = C.SDL_PEN_AXIS_YTILT,
	/// Pen distance to drawing surface. Unidirectional 0.0 to 1.0.
	Distance = C.SDL_PEN_AXIS_DISTANCE,
	/// Pen barrel rotation. Bidirectional -180 to 179.9 (clockwise, 0 is facing up, -180.0 is facing down).
	Rotation = C.SDL_PEN_AXIS_ROTATION,
	/// Pen finger wheel or slider (e.g., Airbrush Pen). Unidirectional 0 to 1.0.
	Slider = C.SDL_PEN_AXIS_SLIDER,
	/// Pressure from squeezing the pen (barrel pressure).
	TangentialPressure = C.SDL_PEN_AXIS_TANGENTIAL_PRESSURE,
};

/// A pen instance.
pub const Pen = struct {
	value: C.SDL_PenID,
};

/// Pen input flags, as reported by various pen events.
pub const InputFlags = struct {
	/// Pen is pressed down.
	Down: bool = false,
	/// Pen button 1 is pressed down.
	Button1: bool = false,
	/// Pen button 2 is pressed down.
	Button2: bool = false,
	/// Pen button 3 is pressed down.
	Button3: bool = false,
	/// Pen button 4 is pressed down.
	Button4: bool = false,
	/// Pen button 5 is pressed down.
	Button5: bool = false,
	/// Eraser tip is pressed down.
	EraserTip: bool = false,

	/// Convert from an SDL value.
	pub fn fromSdl(flags: C.SDL_PenInputFlags) InputFlags {
		return .{
			.Down = (flags & C.SDL_PEN_INPUT_DOWN) != 0,
			.Button1 = (flags & C.SDL_PEN_INPUT_BUTTON_1) != 0,
			.Button2 = (flags & C.SDL_PEN_INPUT_BUTTON_2) != 0,
			.Button3 = (flags & C.SDL_PEN_INPUT_BUTTON_3) != 0,
			.Button4 = (flags & C.SDL_PEN_INPUT_BUTTON_4) != 0,
			.Button5 = (flags & C.SDL_PEN_INPUT_BUTTON_5) != 0,
			.EraserTip = (flags & C.SDL_PEN_INPUT_ERASER_TIP) != 0,
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: InputFlags) C.SDL_PenInputFlags {
		return (if (self.Down) @as(C.SDL_PenInputFlags, C.SDL_PEN_INPUT_DOWN) else 0) |
			(if (self.Button1) @as(C.SDL_PenInputFlags, C.SDL_PEN_INPUT_BUTTON_1) else 0) |
			(if (self.Button2) @as(C.SDL_PenInputFlags, C.SDL_PEN_INPUT_BUTTON_2) else 0) |
			(if (self.Button3) @as(C.SDL_PenInputFlags, C.SDL_PEN_INPUT_BUTTON_3) else 0) |
			(if (self.Button4) @as(C.SDL_PenInputFlags, C.SDL_PEN_INPUT_BUTTON_4) else 0) |
			(if (self.Button5) @as(C.SDL_PenInputFlags, C.SDL_PEN_INPUT_BUTTON_5) else 0) |
			(if (self.EraserTip) @as(C.SDL_PenInputFlags, C.SDL_PEN_INPUT_ERASER_TIP) else 0) |
			0;
	}
};
