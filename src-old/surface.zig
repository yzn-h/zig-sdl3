const C_SDL = @import("c_sdl.zig").C_SDL;
const BlendMode = @import("blend.zig").Mode;
const Error = @import("error.zig").Error;
const Group = @import("properties.zig").Group;
const io_stream = @import("io_stream.zig");
const IRect = @import("rect.zig").IRect;
const pixels = @import("pixels.zig");
const std = @import("std");

/// Surface scaling mode.
pub const ScaleMode = enum(c_int) {
    /// Nearest pixel sample.
    Nearest = C_SDL.SDL_SCALEMODE_NEAREST,
    /// Linear filtering.
    Linear = C_SDL.SDL_SCALEMODE_LINEAR,
    /// Anisotropic filtering.
    Best = C_SDL.SDL_SCALEMODE_BEST,
};

/// How to flip a surface.
pub const FlipMode = enum(c_int) {
    None = C_SDL.SDL_FLIP_NONE,
    Horizontal = C_SDL.SDL_FLIP_HORIZONTAL,
    Vertical = C_SDL.SDL_FLIP_VERTICAL,
};

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

    /// Convert the surface to a new format. Note that the new surface
    pub fn convert(self: Self, format: pixels.Format) !Self {
        const ret = C_SDL.SDL_ConvertSurface(self.handle, @intFromEnum(format));
        if (ret == 0)
            return error.SDLError;
        return .{ .handle = ret };
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

    /// Duplicate the surface. Note that the new surface should be deinit'd.
    pub fn duplicate(self: Self) !Self {
        const ret = C_SDL.SDL_DuplicateSurface(self.handle);
        if (ret == 0)
            return error.SDLError;
        return .{ .handle = ret };
    }

    /// Flip the surface.
    pub fn flip(self: Self, mode: FlipMode) !void {
        if (!C_SDL.SDL_FlipSurface(self.handle, @intFromEnum(mode)))
            return error.SDLError;
    }

    /// Create a surfance from a handle.
    fn fromHandle(handle: SurfaceHandle) Self {
        return .{ .handle = handle };
    }

    /// Get the surface blend mode.
    pub fn getBlendMode(self: Self) !?BlendMode {
        var ret: c_int = undefined;
        if (!C_SDL.SDL_GetSurfaceBlendMode(self.handle, &ret))
            return error.SDLError;
        if (ret == C_SDL.SDL_BLENDMODE_INVALID)
            return null;
        return BlendMode{ .value = ret };
    }

    /// Get the rectangle used for clipping blits onto the surface.
    pub fn getClipRect(self: Self) !IRect {
        var ret: C_SDL.SDL_Rect = undefined;
        if (!C_SDL.SDL_GetSurfaceClipRect(self.handle, &ret))
            return error.SDLError;
        return .{ .x = @intCast(ret.x), .y = @intCast(ret.y), .w = @intCast(ret.w), .h = @intCast(ret.h) };
    }

    /// Get the color key (alpha pixel value) if one exists.
    pub fn getColorKey(self: Self) ?pixels.Pixel {
        var ret: u32 = undefined;
        if (!C_SDL.SDL_GetSurfaceColorKey(self.handle, &ret))
            return null;
        return ret;
    }

    /// Get the color modulation (color multiplies the surface on blit).
    pub fn getColorMod(self: Self) !pixels.Color {
        var ret: pixels.Color = undefined;
        if (!C_SDL.SDL_GetSurfaceColorMod(self.handle, &ret.r, &ret.g, &ret.b))
            return error.SDLError;
        if (!C_SDL.SDL_GetSurfaceAlphaMod(self.handle, &ret.a))
            return error.SDLError;
        return ret;
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

    /// Get if RLE is enabled.
    pub fn getRle(self: Self) bool {
        return C_SDL.SDL_SurfaceHasRLE(self.handle);
    }

    /// If alternate images for the surface are available.
    pub fn hasAlternateImages(self: Self) bool {
        return C_SDL.SDL_SurfaceHasAlternateImages(self.handle);
    }

    /// If the surface has a color key (alpha pixel value).
    pub fn hasColorKey(self: Self) bool {
        return C_SDL.SDL_SurfaceHasColorKey(self.handle);
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

    /// Load a surface from a BMP file.
    pub fn loadBmpFromFile(file: [:0]const u8) !Self {
        const ret = C_SDL.SDL_LoadBMP(file);
        if (ret == 0)
            return error.SDLError;
        return fromHandle(ret);
    }

    /// Load a surface from a BMP file in an IO stream. Optionally close the IO once done.
    pub fn loadBmpFromIo(stream: io_stream.Stream, close_io: bool) !Self {
        const ret = C_SDL.SDL_LoadBMP_IO(stream.handle, close_io);
        if (ret == 0)
            return error.SDLError;
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

    /// Create a new surface scaled to the size specified. Note that the new surface is deinit'd.
    pub fn scale(self: Self, width: u32, height: u32, mode: ScaleMode) !Self {
        const ret = C_SDL.SDL_ScaleSurface(self.handle, @intCast(width), @intCast(height), @intFromEnum(mode));
        if (ret == 0)
            return error.SDLError;
        return .{ .handle = ret };
    }

    /// Set the surface blend mode.
    pub fn setBlendMode(self: Self, mode: BlendMode) !void {
        if (!C_SDL.SDL_SetSurfaceBlendMode(self.handle, mode.value))
            return error.SDLError;
    }

    /// Save the surface as a BMP file.
    pub fn saveBmp(self: Self, file: [:0]const u8) !void {
        if (!C_SDL.SDL_SaveBMP(self.surface, file))
            return error.SDLError;
    }

    /// Save the surface as a BMP file into an IO stream. Optionally closes the IO.
    pub fn saveBmpToIO(self: Self, stream: io_stream.Stream, close_io: bool) !void {
        if (!C_SDL.SDL_SaveBMP_IO(self.surface, stream.handle, close_io))
            return error.SDLError;
    }

    /// When the surface is the destination of a blit, only the the area in the rect will be drawn into. Returns if rectangle intersects the surface at all.
    pub fn setClipRect(self: Self, rect: IRect) bool {
        const tmp = C_SDL.SDL_Rect{ .x = @intCast(rect.x), .y = @intCast(rect.y), .w = @intCast(rect.w), .h = @intCast(rect.h) };
        return C_SDL.SDL_SetSurfaceClipRect(self.handle, &tmp);
    }

    /// Set the color key (transparent color) of the surface. If the key is null, the color key will be disabled.
    pub fn setColorKey(self: Self, key: ?pixels.Pixel) !void {
        if (!C_SDL.SDL_SetSurfaceColorKey(self.handle, key != null, key orelse 0))
            return error.SDLError;
    }

    /// Set the color mod (color to multiply by on blit).
    pub fn setColorMod(self: Self, color: pixels.Color) !void {
        if (!C_SDL.SDL_SetSurfaceColorMod(self.handle, color.r, color.g, color.b) or !C_SDL.SDL_SetSurfaceAlphaMod(self.handle, color.a))
            return error.SDLError;
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

    /// Enable or disable RLE.
    pub fn setRle(self: Self, rle: bool) !void {
        if (!C_SDL.SDL_SetSurfaceRLE(self.handle, rle))
            return error.SDLError;
    }

    /// Unlock the surface after writing pixels.
    pub fn unlock(self: Self) void {
        C_SDL.SDL_UnlockSurface(self.handle);
    }
};
