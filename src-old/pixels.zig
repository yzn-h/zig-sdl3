const C_SDL = @import("c_sdl.zig").C_SDL;
const Error = @import("error.zig").Error;
const std = @import("std");

// TODO: MACROS!!!

/// Raw pixel value.
pub const Pixel = u32;

/// Pixel format type.
pub const PackingType = enum(c_int) {
    Unknown = C_SDL.SDL_PIXELTYPE_UNKNOWN,
    Index1 = C_SDL.SDL_PIXELTYPE_INDEX1,
    Index4 = C_SDL.SDL_PIXELTYPE_INDEX4,
    Index8 = C_SDL.SDL_PIXELTYPE_INDEX8,
    Packed8 = C_SDL.SDL_PIXELTYPE_PACKED8,
    Packed16 = C_SDL.SDL_PIXELTYPE_PACKED16,
    Packed32 = C_SDL.SDL_PIXELTYPE_PACKED32,
    ArrayU8 = C_SDL.SDL_PIXELTYPE_ARRAYU8,
    ArrayU16 = C_SDL.SDL_PIXELTYPE_ARRAYU16,
    ArrayU32 = C_SDL.SDL_PIXELTYPE_ARRAYU32,
    ArrayF16 = C_SDL.SDL_PIXELTYPE_ARRAYF16,
    ArrayF32 = C_SDL.SDL_PIXELTYPE_ARRAYF32,
    Index2 = C_SDL.SDL_PIXELTYPE_INDEX2,
};

/// Pixel format.
pub const Format = enum(c_int) {
    const Self = @This();
    Unknown = C_SDL.SDL_PIXELFORMAT_UNKNOWN,
    Index1Lsb = C_SDL.SDL_PIXELFORMAT_INDEX1LSB,
    Index1Msb = C_SDL.SDL_PIXELFORMAT_INDEX1MSB,
    Index2Lsb = C_SDL.SDL_PIXELFORMAT_INDEX2LSB,
    Index2Msb = C_SDL.SDL_PIXELFORMAT_INDEX2MSB,
    Index4Lsb = C_SDL.SDL_PIXELFORMAT_INDEX4LSB,
    Index4Msb = C_SDL.SDL_PIXELFORMAT_INDEX4MSB,
    Index8 = C_SDL.SDL_PIXELFORMAT_INDEX8,
    Rgb332 = C_SDL.SDL_PIXELFORMAT_RGB332,
    Xrgb4444 = C_SDL.SDL_PIXELFORMAT_XRGB4444,
    Xbgr4444 = C_SDL.SDL_PIXELFORMAT_XBGR4444,
    Xrgb1555 = C_SDL.SDL_PIXELFORMAT_XRGB1555,
    Xbgr1555 = C_SDL.SDL_PIXELFORMAT_XBGR1555,
    Argb4444 = C_SDL.SDL_PIXELFORMAT_ARGB4444,
    Rgba4444 = C_SDL.SDL_PIXELFORMAT_RGBA4444,
    Abgr4444 = C_SDL.SDL_PIXELFORMAT_ABGR4444,
    Bgra4444 = C_SDL.SDL_PIXELFORMAT_BGRA4444,
    Argb1555 = C_SDL.SDL_PIXELFORMAT_ARGB1555,
    Rgba5551 = C_SDL.SDL_PIXELFORMAT_RGBA5551,
    Abgr1555 = C_SDL.SDL_PIXELFORMAT_ABGR1555,
    Bgra5551 = C_SDL.SDL_PIXELFORMAT_BGRA5551,
    Rgb565 = C_SDL.SDL_PIXELFORMAT_RGB565,
    Bgr565 = C_SDL.SDL_PIXELFORMAT_BGR565,
    Rgb24 = C_SDL.SDL_PIXELFORMAT_RGB24,
    Bgr24 = C_SDL.SDL_PIXELFORMAT_BGR24,
    Xrgb8888 = C_SDL.SDL_PIXELFORMAT_XRGB8888,
    Rgbx8888 = C_SDL.SDL_PIXELFORMAT_RGBX8888,
    Xbgr8888 = C_SDL.SDL_PIXELFORMAT_XBGR8888,
    Bgrx8888 = C_SDL.SDL_PIXELFORMAT_BGRX8888,
    Argb8888 = C_SDL.SDL_PIXELFORMAT_ARGB8888,
    Rgba8888 = C_SDL.SDL_PIXELFORMAT_RGBA8888,
    Abgr8888 = C_SDL.SDL_PIXELFORMAT_ABGR8888,
    Bgra8888 = C_SDL.SDL_PIXELFORMAT_BGRA8888,
    Xrgb2101010 = C_SDL.SDL_PIXELFORMAT_XRGB2101010,
    Xbgr2101010 = C_SDL.SDL_PIXELFORMAT_XBGR2101010,
    Argb2101010 = C_SDL.SDL_PIXELFORMAT_ARGB2101010,
    Abgr2101010 = C_SDL.SDL_PIXELFORMAT_ABGR2101010,
    Rgb48 = C_SDL.SDL_PIXELFORMAT_RGB48,
    Bgr48 = C_SDL.SDL_PIXELFORMAT_BGR48,
    Rgba64 = C_SDL.SDL_PIXELFORMAT_RGBA64,
    Argb64 = C_SDL.SDL_PIXELFORMAT_ARGB64,
    Bgra64 = C_SDL.SDL_PIXELFORMAT_BGRA64,
    Abgr64 = C_SDL.SDL_PIXELFORMAT_ABGR64,
    Rgb48_FLOAT = C_SDL.SDL_PIXELFORMAT_RGB48_FLOAT,
    Bgr48_FLOAT = C_SDL.SDL_PIXELFORMAT_BGR48_FLOAT,
    Rgba64_FLOAT = C_SDL.SDL_PIXELFORMAT_RGBA64_FLOAT,
    Argb64_FLOAT = C_SDL.SDL_PIXELFORMAT_ARGB64_FLOAT,
    Bgra64_FLOAT = C_SDL.SDL_PIXELFORMAT_BGRA64_FLOAT,
    Abgr64_FLOAT = C_SDL.SDL_PIXELFORMAT_ABGR64_FLOAT,
    Rgb96_FLOAT = C_SDL.SDL_PIXELFORMAT_RGB96_FLOAT,
    Bgr96_FLOAT = C_SDL.SDL_PIXELFORMAT_BGR96_FLOAT,
    Rgba128_FLOAT = C_SDL.SDL_PIXELFORMAT_RGBA128_FLOAT,
    Argb128_FLOAT = C_SDL.SDL_PIXELFORMAT_ARGB128_FLOAT,
    Bgra128_FLOAT = C_SDL.SDL_PIXELFORMAT_BGRA128_FLOAT,
    Abgr128_FLOAT = C_SDL.SDL_PIXELFORMAT_ABGR128_FLOAT,
    Yv12 = C_SDL.SDL_PIXELFORMAT_YV12,
    Iyuv = C_SDL.SDL_PIXELFORMAT_IYUV,
    Yuy2 = C_SDL.SDL_PIXELFORMAT_YUY2,
    Uyvy = C_SDL.SDL_PIXELFORMAT_UYVY,
    Yvyu = C_SDL.SDL_PIXELFORMAT_YVYU,
    Nv12 = C_SDL.SDL_PIXELFORMAT_NV12,
    Nv21 = C_SDL.SDL_PIXELFORMAT_NV21,
    P010 = C_SDL.SDL_PIXELFORMAT_P010,
    ExternalOes = C_SDL.SDL_PIXELFORMAT_EXTERNAL_OES,

    /// If the pixel flag is valid.
    pub fn flag(self: Self) bool {
        return C_SDL.SDL_PIXELFLAG(@intFromEnum(self)) > 0;
    }

    /// Get a format for masks. Returns unknown if format is not possible.
    pub fn forMasks(bpp: u32, r_mask: u32, g_mask: u32, b_mask: u32, a_mask: u32) void {
        return C_SDL.SDL_GetPixelFormatForMasks(@intCast(bpp), r_mask, g_mask, b_mask, a_mask);
    }

    /// Convert a color to a raw pixel value in this format.
    pub fn mapRgba(self: Self, palette: ?Palette, color: Color) !Pixel {
        const format = C_SDL.SDL_GetPixelFormatDetails(@intFromEnum(self));
        if (format == 0)
            return error.SDLError;
        return C_SDL.SDL_MapRGBA(format, if (palette) |val| val.handle else 0, color.r, color.g, color.b, color.a);
    }

    /// Get a mask for the format.
    pub fn masks(self: Self) !struct { bpp: u32, r_mask: u32, g_mask: u32, b_mask: u32, a_mask: u32 } {
        var ret: struct { bpp: u32, r_mask: u32, g_mask: u32, b_mask: u32, a_mask: u32 } = undefined;
        var bpp: c_int = undefined;
        if (!C_SDL.SDL_GetMasksForPixelFormat(@intFromEnum(self), &bpp, &ret.r_mask, &ret.g_mask, &ret.b_mask, &ret.a_mask))
            return error.SDLError;
        ret.bpp = @intCast(bpp);
        return ret;
    }

    /// Get the name of the format. Null if format is not recognized.
    pub fn name(self: Self) ?[]const u8 {
        const ret = C_SDL.SDL_GetPixelFormatName(@intFromEnum(self));
        if (std.mem.eql(u8, ret, "SDL_PIXELFORMAT_UNKNOWN"))
            return null;
        return std.mem.span(ret);
    }

    /// Get how pixels are packed.
    pub fn packingType(self: Self) PackingType {
        return @enumFromInt(C_SDL.SDL_PIXELTYPE(@intFromEnum(self)));
    }

    /// Get a color from a pixel encoded in this format.
    pub fn getRgba(self: Self, palette: ?Palette, pixel: Pixel) !Color {
        const format = C_SDL.SDL_GetPixelFormatDetails(@intFromEnum(self));
        if (format == 0)
            return error.SDLError;
        var r: u8 = undefined;
        var g: u8 = undefined;
        var b: u8 = undefined;
        var a: u8 = undefined;
        C_SDL.SDL_GetRGBA(pixel, format, if (palette) |val| val.handle else 0, &r, &g, &b, &a);
        return .{ .r = r, .g = g, .b = b, .a = a };
    }
};

/// Pixel colorspace.
pub const ColorSpace = enum(c_int) {
    const Self = @This();
    Unknown = C_SDL.SDL_COLORSPACE_UNKNOWN,
    Srgb = C_SDL.SDL_COLORSPACE_SRGB,
    SrgbLinear = C_SDL.SDL_COLORSPACE_SRGB_LINEAR,
    Hdr10 = C_SDL.SDL_COLORSPACE_HDR10,
    Jpeg = C_SDL.SDL_COLORSPACE_JPEG,
    Bt601Limited = C_SDL.SDL_COLORSPACE_BT601_LIMITED,
    Bt601Full = C_SDL.SDL_COLORSPACE_BT601_FULL,
    Bt709Limited = C_SDL.SDL_COLORSPACE_BT709_LIMITED,
    Bt709Full = C_SDL.SDL_COLORSPACE_BT709_FULL,
    Bt2020Limited = C_SDL.SDL_COLORSPACE_BT2020_LIMITED,
    Bt2020Full = C_SDL.SDL_COLORSPACE_BT2020_FULL,

    /// Get the default colorspace for RGB.
    pub fn rgbDefault() Self {
        return @enumFromInt(C_SDL.SDL_COLORSPACE_RGB_DEFAULT);
    }

    /// Get the default colorspace for YUV.
    pub fn yuvDefault() Self {
        return @enumFromInt(C_SDL.SDL_COLORSPACE_YUV_DEFAULT);
    }
};

/// An RGBA32 color.
pub const Color = C_SDL.SDL_Color;

/// An RGBA128 float color.
pub const FColor = C_SDL.SDL_FColor;

/// Palette.
pub const PaletteHandle = *C_SDL.SDL_Palette;

/// A palette.
pub const Palette = struct {
    const Self = @This();
    handle: PaletteHandle,

    /// Destroy the palette.
    pub fn deinit(self: Self) void {
        C_SDL.SDL_DestroyPalette(self.handle);
    }

    /// Create a new palette.
    pub fn init(num_colors: usize) !Self {
        const ret = C_SDL.SDL_CreatePalette(@intCast(num_colors));
        if (ret == 0)
            return error.SDLError;
        return .{ .handle = ret };
    }

    /// Set palette colors starting at the first_color index.
    pub fn setColors(self: Self, colors: []Color, first_color: usize) !void {
        if (!C_SDL.SDL_SetPaletteColors(self.handle, colors.ptr, @intCast(first_color), @intCast(colors.len)))
            return error.SDLError;
    }

    /// Get the slice of colors.
    pub fn slice(self: Self) []Color {
        return .{ .ptr = @ptrCast(self.handle.colors), .len = @intCast(self.handle.ncolors) };
    }
};
