// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Day of the week.
pub const Day = enum(c_int) {
	Sunday = 0,
	Monday = 1,
	Tuesday = 2,
	Wednesday = 3,
	Thursday = 4,
	Friday = 5,
	Saturday = 6,
};

/// Month of the year.
pub const Month = enum(c_int) {
	January = 1,
	February = 2,
	March = 3,
	April = 4,
	May = 5,
	June = 6,
	July = 7,
	August = 8,
	September = 9,
	October = 10,
	November = 11,
	December = 12,
};

/// The preferred date format of the current system locale.
pub const DateFormat = enum(c_uint) {
	YearMonthDay = C.SDL_DATE_FORMAT_YYYYMMDD,
	DayMonthYear = C.SDL_DATE_FORMAT_DDMMYYYY,
	MonthDayYear = C.SDL_DATE_FORMAT_MMDDYYYY,
};

/// The preferred time format of the current system locale.
pub const TimeFormat = enum(c_uint) {
	TwentyFourHour = C.SDL_TIME_FORMAT_24HR,
	TwelveHour = C.SDL_TIME_FORMAT_12HR,
};

/// Nanoseconds since the unix epoch.
pub const Time = struct {
	value: C.SDL_Time,

	/// Gets the current value of the system realtime clock in nanoseconds since Jan 1, 1970 in Universal Coordinated Time (UTC).
	pub fn getCurrent() !Time {
		var time: C.SDL_Time = undefined;
		const ret = C.SDL_GetCurrentTime(
			&time,
		);
		if (!ret)
			return error.SdlError;
		return Time{ .value = time };
	}

	/// Gets the current preferred date and time format for the system locale. This is a *slow* call and should only be used once ideally.
	pub fn getLocalePreferences(
		self: Time,
	) !struct { dateFormat: DateFormat, timeFormat: TimeFormat } {
		var dateFormat: C.SDL_DateFormat = undefined;
		var timeFormat: C.SDL_TimeFormat = undefined;
		const ret = C.SDL_GetDateTimeLocalePreferences(
			self.value,
			&dateFormat,
			&timeFormat,
		);
		if (!ret)
			return error.SdlError;
		return .{ .dateFormat = @enumFromInt(dateFormat), .timeFormat = @enumFromInt(timeFormat) };
	}

	/// Converts a calendar time to an SDL_Time in nanoseconds since the epoch.
	pub fn fromDateTime(
		date_time: DateTime,
	) !Time {
		const date_time_sdl: C.SDL_DateTime = date_time.toSdl();
		var time: C.SDL_Time = undefined;
		const ret = C.SDL_DateTimeToTime(
			&date_time_sdl,
			&time,
		);
		if (!ret)
			return error.SdlError;
		return Time{ .value = time };
	}

	/// Converts an SDL time to a windows FILETIME.
	pub fn toWindows(
		self: Time,
	) struct { lowDateTime: u32, highDateTime: u32 } {
		var lowDateTime: u32 = undefined;
		var highDateTime: u32 = undefined;
		const ret = C.SDL_TimeToWindows(
			self.value,
			&lowDateTime,
			&highDateTime,
		);
		_ = ret;
		return .{ .lowDateTime = lowDateTime, .highDateTime = highDateTime };
	}

	/// Converts a windows FILETIME to an SDL time.
	pub fn fromWindows(
		lowDateTime: u32,
		highDateTime: u32,
	) Time {
		const ret = C.SDL_TimeFromWindows(
			@intCast(lowDateTime),
			@intCast(highDateTime),
		);
		return Time{ .value = ret };
	}
};

/// A structure holding a calendar date and time broken down into it's components.
pub const DateTime = struct {
	year: u31,
	month: Month,
	/// Range is [0-31] inclusively.
	day: u5,
	/// Range is [0-23] inclusively.
	hour: u5,
	/// Range is [0-59] inclusively.
	minute: u6,
	/// Range is [0-59] inclusively.
	second: u6,
	/// Range is [0-999999999] inclusively.
	nanosecond: u31,
	day_of_week: Day,
	/// Seconds east of UTC.
	utc_offset: i32,

	/// Convert from an SDL value.
	pub fn fromSdl(data: C.SDL_DateTime) DateTime {
		return .{
			.year = @intCast(data.year),
			.month = @enumFromInt(data.month),
			.day = @intCast(data.day),
			.hour = @intCast(data.hour),
			.minute = @intCast(data.minute),
			.second = @intCast(data.second),
			.nanosecond = @intCast(data.nanosecond),
			.day_of_week = @enumFromInt(data.day_of_week),
			.utc_offset = @intCast(data.utc_offset),
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: DateTime) C.SDL_DateTime {
		return .{
			.year = @intCast(self.year),
			.month = @intFromEnum(self.month),
			.day = @intCast(self.day),
			.hour = @intCast(self.hour),
			.minute = @intCast(self.minute),
			.second = @intCast(self.second),
			.nanosecond = @intCast(self.nanosecond),
			.day_of_week = @intFromEnum(self.day_of_week),
			.utc_offset = @intCast(self.utc_offset),
		};
	}

	/// Converts an SDL time in nanoseconds since the epoch to a calendar time in the SDL date time format.
	pub fn fromTime(
		time: Time,
		local_instead_of_utc: bool,
	) !DateTime {
		var date_time: C.SDL_DateTime = undefined;
		const ret = C.SDL_TimeToDateTime(
			time.value,
			&date_time,
			local_instead_of_utc,
		);
		if (!ret)
			return error.SdlError;
		return ret;
	}
};

/// Get the number of days in a month for a given year.
pub fn getDaysInMonth(
	year: u31,
	month: Month,
) !u5 {
	const ret = C.SDL_GetDaysInMonth(
		@intCast(year),
		@intFromEnum(month),
	);
	if (ret == -1)
		return error.SdlError;
	return @intCast(ret);
}

/// Get the day of a given year with value [0-365].
pub fn getDayOfYear(
	year: u31,
	month: Month,
	day: u5,
) !u9 {
	const ret = C.SDL_GetDayOfYear(
		@intCast(year),
		@intFromEnum(month),
		@intCast(day),
	);
	if (ret == -1)
		return error.SdlError;
	return @intCast(ret);
}

/// Get the day of a given week.
pub fn getDayOfWeek(
	year: u31,
	month: Month,
	day: u5,
) !Day {
	const ret = C.SDL_GetDayOfWeek(
		@intCast(year),
		@intFromEnum(month),
		@intCast(day),
	);
	if (ret == -1)
		return error.SdlError;
	return @enumFromInt(ret);
}

// Ensure time and date recognition works.
test "Dates" {
	try std.testing.expect(try getDaysInMonth(2018, Month.February) == 28);
	try std.testing.expect(try getDaysInMonth(2020, Month.February) == 29);
	try std.testing.expect(try getDaysInMonth(2014, Month.October) == 31);
	try std.testing.expect(try getDayOfYear(1972, Month.June, 13) == 164);
	try std.testing.expect(try getDayOfYear(2057, Month.March, 12) == 70);
	try std.testing.expect(try getDayOfYear(2018, Month.September, 27) == 269);
	try std.testing.expectError(error.SdlError, getDayOfYear(2020, Month.February, 31));
	try std.testing.expect(try getDayOfWeek(2001, Month.November, 2) == Day.Friday);
	try std.testing.expect(try getDayOfWeek(1984, Month.January, 11) == Day.Wednesday);
	try std.testing.expect(try getDayOfWeek(2024, Month.October, 9) == Day.Wednesday);
	try std.testing.expectError(error.SdlError, getDayOfWeek(2020, Month.February, 31));
}
