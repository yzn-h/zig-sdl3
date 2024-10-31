// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// The different sensors defined by SDL.
pub const Type = enum(c_int) {
	/// Unknown sensor type.
	Unknown = C.SDL_SENSOR_UNKNOWN,
	Accelerometer = C.SDL_SENSOR_ACCEL,
	Gyroscope = C.SDL_SENSOR_GYRO,
	/// Accelerometer for left Joy-Con controller and Wii nunchuk.
	AccelerometerLeft = C.SDL_SENSOR_ACCEL_L,
	/// Gyroscope for left Joy-Con controller.
	GyroscopeLeft = C.SDL_SENSOR_GYRO_L,
	/// Accelerometer for right Joy-Con controller.
	AccelerometerRight = C.SDL_SENSOR_ACCEL_R,
	/// Gyroscope for right Joy-Con controller.
	GyroscopeRight = C.SDL_SENSOR_GYRO_R,
};

/// This is a unique ID for a sensor for the time it is connected to the system, and is never reused for the lifetime of the application.
pub const ID = struct {
	value: C.SDL_SensorID,

	/// Get the implementation dependent name of a sensor.
	pub fn getName(
		self: ID,
	) ?[]const u8 {
		const ret = C.SDL_GetSensorName(
			self.value,
		);
		if (ret == null)
			return null;
		return std.mem.span(ret);
	}

	/// Get the type of a sensor.
	pub fn getType(
		self: ID,
	) ?Type {
		const ret = C.SDL_GetSensorType(
			self.value,
		);
		if (ret == C.SDL_SENSOR_INVALID)
			return null;
		return @enumFromInt(ret);
	}

	/// Get the platform dependent type of a sensor.
	pub fn getNonPortableType(
		self: ID,
	) !c_int {
		const ret = C.SDL_GetSensorNonPortableType(
			self.value,
		);
		if (ret == -1)
			return error.SdlError;
		return @intCast(ret);
	}

	/// Return the SDL_Sensor associated with an instance ID.
	pub fn getSensor(
		self: ID,
	) Sensor {
		const ret = C.SDL_GetSensorFromID(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return Sensor{ .value = ret.? };
	}

	/// Get a list of currently connected sensors. Result must be freed.
    pub fn getAll(allocator: std.mem.Allocator) ![]ID {
        var count: c_int = undefined;
        const ret = C.SDL_GetSensors(
            &count,
        );
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

/// Sensor to obtain data from.
pub const Sensor = struct {
	value: *C.SDL_Sensor,

	/// Open a sensor for use.
	pub fn init(
		id: ID,
	) Sensor {
		const ret = C.SDL_OpenSensor(
			id.value,
		);
		if (ret == null)
			return error.SdlError;
		return Sensor{ .value = ret.? };
	}

	/// Get the properties associated with a sensor.
	pub fn getProperties(
		self: Sensor,
	) properties.Group {
		const ret = C.SDL_GetSensorProperties(
			self.value,
		);
		if (ret == 0)
			return error.SdlError;
		return properties.Group{ .value = ret };
	}

	/// Get the implementation dependent name of a sensor.
	pub fn getName(
		self: Sensor,
	) ?[]const u8 {
		const ret = C.SDL_GetSensorName(
			self.value,
		);
		if (ret == null)
			return null;
		return std.mem.span(ret);
	}

	/// Get the type of a sensor.
	pub fn getType(
		self: Sensor,
	) ?Type {
		const ret = C.SDL_GetSensorType(
			self.value,
		);
		if (ret == C.SDL_SENSOR_INVALID)
			return null;
		return @enumFromInt(ret);
	}

	/// Get the platform dependent type of a sensor.
	pub fn getNonPortableType(
		self: Sensor,
	) !c_int {
		const ret = C.SDL_GetSensorNonPortableType(
			self.value,
		);
		if (ret == -1)
			return error.SdlError;
		return @intCast(ret);
	}

	/// Get the instance ID of a sensor.
	pub fn getID(
		self: Sensor,
	) !ID {
		const ret = C.SDL_GetSensorID(
			self.value,
		);
		if (ret == 0)
			return error.SdlError;
		return ID{ .value = ret };
	}

	/// Get the current state of an opened sensor and writes it to the given slice.
	pub fn getData(
		self: Sensor,
		data: []f32,
	) !void {
		const ret = C.SDL_GetSensorData(
			self.value,
			data.ptr,
			@intCast(data.len),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Close a sensor previously opened with `Sensor.init`.
	pub fn deinit(
		self: Sensor,
	) void {
		const ret = C.SDL_CloseSensor(
			self.value,
		);
		_ = ret;
	}

	/// Update the current state of the open sensors.
	pub fn update() void {
		const ret = C.SDL_UpdateSensors();
		_ = ret;
	}
};

const properties = @import("properties.zig");
