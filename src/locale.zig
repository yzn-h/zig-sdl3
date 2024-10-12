// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Locale data.
pub const Locale = struct {
	/// Language in the ISO-639 spec.
	language: [:0]const u8,
	/// Country code in the ISO-3166 spec.
	country: ?[:0]const u8,

	/// Convert from an SDL value.
	pub fn fromSdl(data: C.SDL_Locale) Locale {
		return .{
			.language = std.mem.span(data.language),
			.country = if (data.country == null) null else std.mem.span(data.country),
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: Locale) C.SDL_Locale {
		return .{
			.language = self.language,
			.country = if (self.country) |str_capture| str_capture.ptr else null,
		};
	}

	/// Get preferred locals. Result must be freed.
    pub fn getPreferred(allocator: std.mem.Allocator) ![]Locale {
        var cnt: c_int = undefined;
        const ret = C.SDL_GetPreferredLocales(&cnt);
        var converted_ret = try allocator.alloc(Locale, @intCast(cnt));
        for (0..cnt) |ind| {
            const sdl = ret[ind].*;
            var zig = &converted_ret[ind];
            zig.language = try allocator.allocSentinel(u8, std.mem.len(sdl.language), 0);
            @memcpy(zig.language, sdl.language);
            if (sdl.country == null) {
                zig.country = null;
            } else {
                zig.country = try allocator.allocSentinel(u8, std.mem.len(sdl.country), 0);
                @memcpy(zig.country, sdl.country);
            }
        }
        C.SDL_free(ret);
        return converted_ret;
    }
};
