const C_SDL = @import("c_sdl.zig").C_SDL;
const Error = @import("error.zig").Error;
const Group = @import("properties.zig").Group;
const pixels = @import("pixels.zig");
const std = @import("std");

/// Surface handle. A lot of stuff is read only so.
pub const SurfaceHandle = *C_SDL.SDL_Surface;

/// A surface for drawing to.
pub const Surface = struct {
    const Self = @This();
    handle: SurfaceHandle,

    /// Properties of the surface.
    pub const Properties = struct {
        const PSelf = @This();
        group: Group,

        /// Uninitialize the properties.
        pub fn deinit(self: PSelf) void {
            self.group.deinit();
        }

        /// Get the init properties.
        pub fn init() !PSelf {
            return .{
                .group = try Group.init(),
            };
        }

        /// Get the HDR headroom.
        pub fn getHdrHeadroom(self: PSelf) ?f32 {
            return self.group.getFloat(C_SDL.SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT);
        }

        /// Get the SDR white point.
        pub fn getSdrWhitePoint(self: PSelf) ?f32 {
            return self.group.getFloat(C_SDL.SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT);
        }

        /// Get the tonemap operator.
        pub fn getTonemapOperator(self: PSelf) ?[]const u8 {
            return self.group.getString(C_SDL.SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING);
        }

        /// Set the HDR headroom.
        pub fn setHdrHeadroom(self: PSelf, hdr_headroom: ?f32) !void {
            try self.group.setFloat(C_SDL.SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT, hdr_headroom);
        }

        /// Set the SDR white point.
        pub fn setSdrWhitePoint(self: PSelf, sdr_white_point: ?f32) !void {
            try self.group.setFloat(C_SDL.SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT, sdr_white_point);
        }

        /// Set the tonemap operator.
        pub fn setTonemapOperator(self: PSelf, tonemap_operator: ?[:0]const u8) !void {
            try self.group.setString(C_SDL.SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING, tonemap_operator);
        }
    };

    /// Add an alternate image.
    pub fn addAlternateImage(self: Self, other: Self) !void {
        if (!C_SDL.SDL_AddSurfaceAlternateImage(self.handle, other.handle))
            return error.SDLError;
    }

    /// Create a new palette for the surface.
    pub fn createPalette(self: Self) !pixels.Palette {
        const ret = C_SDL.SDL_CreateSurfacePalette(self.handle);
        if (ret == 0)
            return error.SDLError;
        return .{ .handle = ret };
    }

    // Deinitialize the surface.
    pub fn deinit(self: Self) void {
        C_SDL.SDL_DestroySurface(self.handle);
    }

    /// Create a surfance from a handle.
    fn fromHandle(handle: SurfaceHandle) Self {
        return .{ .handle = handle };
    }

    /// Get the colorspace of the surface.
    pub fn getColorspace(self: Self) pixels.ColorSpace {
        return @enumFromInt(C_SDL.SDL_GetSurfaceColorspace(self.handle));
    }

    /// Get surface images including this one. Memory returned must be freed.
    pub fn getImages(self: Self, allocator: std.mem.Allocator) ![]Self {
        var count: c_int = undefined;
        const tmp = C_SDL.SDL_GetSurfaceImages(self.handle, &count);
        defer C_SDL.SDL_free(tmp);
        if (tmp == 0)
            return error.SDLError;
        var ret = try allocator.alloc(Surface, @intCast(count));
        for (0..count) |ind| {
            ret[ind] = fromHandle(tmp[ind]);
        }
        return ret;
    }

    /// Get the palette for the surface, or null if none are in use.
    pub fn getPalette(self: Self) ?pixels.Palette {
        const ret = C_SDL.SDL_GetSurfacePalette(self.handle);
        if (ret == 0)
            return null;
        return .{ .handle = ret };
    }

    /// If alternate images for the surface are available.
    pub fn hasAlternateImages(self: Self) bool {
        return C_SDL.SDL_SurfaceHasAlternateImages(self.handle);
    }

    /// Initialize a surface.
    pub fn init(width: usize, height: usize, format: pixels.Format) !Self {
        const ret = C_SDL.SDL_CreateSurface(@intCast(width), @intCast(height), @intFromEnum(format));
        if (ret == 0)
            return error.SDL_Error;
        return fromHandle(ret);
    }

    /// Initialize a surface from existing pixels. Pixels can be null, the pitch is the bytes between each row including padding.
    pub fn initFrom(width: usize, height: usize, format: pixels.Format, from: ?*anyopaque, pitch: usize) !Self {
        const ret = C_SDL.SDL_CreateSurfaceFrom(@intCast(width), @intCast(height), @intFromEnum(format), from, @intCast(pitch));
        if (ret == 0)
            return error.SDL_Error;
        return fromHandle(ret);
    }

    /// Lock a surface for direct pixel access.
    pub fn lock(self: Self) !void {
        if (!C_SDL.SDL_LockSurface(self.handle))
            return error.SDLError;
    }

    /// Get the surface properties.
    pub fn properties(self: Self) Properties {
        const ret = C_SDL.SDL_GetSurfaceProperties(self.handle);
        if (ret == Group.invalid.id)
            return error.SDLError;
        return .{ .group = .{ .id = ret } };
    }

    /// Remove all alternate images for a surface.
    pub fn removeAllAlternateImages(self: Self) void {
        C_SDL.SDL_RemoveSurfaceAlternateImages(self.handle);
    }

    /// Set the colorspace of the surface.
    pub fn setColorspace(self: Self, color_space: pixels.ColorSpace) !void {
        if (!C_SDL.SDL_SetSurfaceColorspace(self.handle, @intFromEnum(color_space)))
            return error.SDLError;
    }

    /// Set the palette of the surface.
    pub fn setPalette(self: Self, palette: pixels.Palette) !void {
        if (!C_SDL.SDL_SetSurfacePalette(self.handle, palette.handle))
            return error.SDLError;
    }

    /// Unlock the surface after writing pixels.
    pub fn unlock(self: Self) void {
        C_SDL.SDL_UnlockSurface(self.handle);
    }
};
