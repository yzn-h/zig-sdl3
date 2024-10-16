// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Pixel type.
pub const Type = enum(c_uint) {
    Index1 = C.SDL_PIXELTYPE_INDEX1,
    Index2 = C.SDL_PIXELTYPE_INDEX2,
    Index4 = C.SDL_PIXELTYPE_INDEX4,
    Index8 = C.SDL_PIXELTYPE_INDEX8,
    Packed8 = C.SDL_PIXELTYPE_PACKED8,
    Packed16 = C.SDL_PIXELTYPE_PACKED16,
    Packed32 = C.SDL_PIXELTYPE_PACKED32,
    ArrayU8 = C.SDL_PIXELTYPE_ARRAYU8,
    ArrayU16 = C.SDL_PIXELTYPE_ARRAYU16,
    ArrayU32 = C.SDL_PIXELTYPE_ARRAYU32,
    ArrayF16 = C.SDL_PIXELTYPE_ARRAYF16,
    ArrayF32 = C.SDL_PIXELTYPE_ARRAYF32,
};

/// Bitmap pixel order, high bit -> low bit.
pub const IndexOrder = enum(c_uint) {
    None = C.SDL_BITMAPORDER_NONE,
    HighToLow = C.SDL_BITMAPORDER_4321,
    LowToHigh = C.SDL_BITMAPORDER_1234,
};

/// Packed component order, high bit -> low bit.
pub const PackedOrder = enum(c_uint) {
    None = C.SDL_PACKEDORDER_NONE,
    Xrgb = C.SDL_PACKEDORDER_XRGB,
    Rgbx = C.SDL_PACKEDORDER_RGBX,
    Argb = C.SDL_PACKEDORDER_ARGB,
    Rgba = C.SDL_PACKEDORDER_RGBA,
    Xbgr = C.SDL_PACKEDORDER_XBGR,
    Bgrx = C.SDL_PACKEDORDER_BGRX,
    Abgr = C.SDL_PACKEDORDER_ABGR,
    Bgra = C.SDL_PACKEDORDER_BGRA,
};

/// Array component order, low byte -> high byte.
pub const ArrayOrder = enum(c_uint) {
    None = C.SDL_ARRAYORDER_NONE,
    Rgb = C.SDL_ARRAYORDER_RGB,
    Rgba = C.SDL_ARRAYORDER_RGBA,
    Argb = C.SDL_ARRAYORDER_ARGB,
    Bgr = C.SDL_ARRAYORDER_BGR,
    Bgra = C.SDL_ARRAYORDER_BGRA,
    Abgr = C.SDL_ARRAYORDER_ABGR,
};

/// Packed component layout.
pub const Layout = enum(c_uint) {
    None = C.SDL_PACKEDLAYOUT_NONE,
    Bit_3_3_2 = C.SDL_PACKEDLAYOUT_332,
    Bit_4_4_4_4 = C.SDL_PACKEDLAYOUT_4444,
    Bit_1_5_5_5 = C.SDL_PACKEDLAYOUT_1555,
    Bit_5_5_5_1 = C.SDL_PACKEDLAYOUT_5551,
    Bit_5_6_5 = C.SDL_PACKEDLAYOUT_565,
    Bit_8_8_8_8 = C.SDL_PACKEDLAYOUT_8888,
    Bit_2_10_10_10 = C.SDL_PACKEDLAYOUT_2101010,
    Bit_10_10_10_2 = C.SDL_PACKEDLAYOUT_1010102,
};

/// Colorspace color type.
pub const ColorType = enum(c_uint) {
    Rgb = C.SDL_COLOR_TYPE_RGB,
    Ycbcr = C.SDL_COLOR_TYPE_YCBCR,
};

/// Colorspace color range, as described by https://www.itu.int/rec/R-REC-BT.2100-2-201807-I/en.
pub const ColorRange = enum(c_uint) {
    Limited = C.SDL_COLOR_RANGE_LIMITED,
    Full = C.SDL_COLOR_RANGE_FULL,
};

/// Colorspace color primaries, as described by https://www.itu.int/rec/T-REC-H.273-201612-S/en.
pub const ColorPrimaries = enum(c_uint) {
    /// ITU-R BT.709-6.
    BT709 = C.SDL_COLOR_PRIMARIES_BT709,
    UNSPECIFIED = C.SDL_COLOR_PRIMARIES_UNSPECIFIED,
    /// ITU-R BT.470-6 System M.
    BT470M = C.SDL_COLOR_PRIMARIES_BT470M,
    /// ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625.
    BT470BG = C.SDL_COLOR_PRIMARIES_BT470BG,
    /// ITU-R BT.601-7 525, SMPTE 170M.
    BT601 = C.SDL_COLOR_PRIMARIES_BT601,
    /// SMPTE 240M, functionally the same as SDL_COLOR_PRIMARIES_BT601.
    SMPTE240 = C.SDL_COLOR_PRIMARIES_SMPTE240,
    /// Generic film (color filters using Illuminant C).
    GENERIC_FILM = C.SDL_COLOR_PRIMARIES_GENERIC_FILM,
    /// ITU-R BT.2020-2 / ITU-R BT.2100-0
    BT2020 = C.SDL_COLOR_PRIMARIES_BT2020,
    /// SMPTE ST 428-1SMPTE ST 428-1.
    XYZ = C.SDL_COLOR_PRIMARIES_XYZ,
    /// SMPTE RP 431-2.
    SMPTE431 = C.SDL_COLOR_PRIMARIES_SMPTE431,
    /// SMPTE EG 432-1 / DCI P3.
    SMPTE432 = C.SDL_COLOR_PRIMARIES_SMPTE432,
    /// EBU Tech. 3213-E.
    EBU3213 = C.SDL_COLOR_PRIMARIES_EBU3213,
    Custom = C.SDL_COLOR_PRIMARIES_CUSTOM,
};

/// Pixel format.
pub const Format = struct {
    value: c_uint,
    pub const Index_1_lsb = Format{ .value = C.SDL_PIXELFORMAT_INDEX1LSB };
    pub const index_1_msb = Format{ .value = C.SDL_PIXELFORMAT_INDEX1MSB };
    pub const index_2_lsb = Format{ .value = C.SDL_PIXELFORMAT_INDEX2LSB };
    pub const index_2_msb = Format{ .value = C.SDL_PIXELFORMAT_INDEX2MSB };
    pub const index_4_lsb = Format{ .value = C.SDL_PIXELFORMAT_INDEX4LSB };
    pub const index_4_msb = Format{ .value = C.SDL_PIXELFORMAT_INDEX4MSB };
    pub const index_8 = Format{ .value = C.SDL_PIXELFORMAT_INDEX8 };
    pub const packed_rgb_3_3_2 = Format{ .value = C.SDL_PIXELFORMAT_RGB332 };
    pub const packed_xrgb_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_XRGB4444 };
    pub const packed_xbgr_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_XBGR4444 };
    pub const packed_xrgb_1_5_5_5 = Format{ .value = C.SDL_PIXELFORMAT_XRGB1555 };
    pub const packed_xbgr_1_5_5_5 = Format{ .value = C.SDL_PIXELFORMAT_XBGR1555 };
    pub const packed_argb_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_ARGB4444 };
    pub const packed_rgba_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_RGBA4444 };
    pub const packed_abgr_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_ABGR4444 };
    pub const packed_bgra_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_BGRA4444 };
    pub const packed_argb_1_5_5_5 = Format{ .value = C.SDL_PIXELFORMAT_ARGB1555 };
    pub const packed_rgba_5_5_5_1 = Format{ .value = C.SDL_PIXELFORMAT_RGBA5551 };
    pub const packed_abgr_1_5_5_5 = Format{ .value = C.SDL_PIXELFORMAT_ABGR1555 };
    pub const packed_bgra_5_5_5_1 = Format{ .value = C.SDL_PIXELFORMAT_BGRA5551 };
    pub const packed_rgb_5_6_5 = Format{ .value = C.SDL_PIXELFORMAT_RGB565 };
    pub const packed_bgr_5_6_5 = Format{ .value = C.SDL_PIXELFORMAT_BGR565 };
    pub const arr_rgb_24 = Format{ .value = C.SDL_PIXELFORMAT_RGB24 };
    pub const arr_bgr_24 = Format{ .value = C.SDL_PIXELFORMAT_BGR24 };
    pub const packed_xrgb_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_XRGB8888 };
    pub const packed_rgbx_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_RGBX8888 };
    pub const packed_xbgr_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_XBGR8888 };
    pub const packed_bgrx_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_BGRX8888 };
    pub const packed_argb_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_ARGB8888 };
    pub const packed_rgba_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_RGBA8888 };
    pub const packed_abgr_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_ABGR8888 };
    pub const packed_bgra_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_BGRA8888 };
    pub const packed_xrgb_2_10_10_10 = Format{ .value = C.SDL_PIXELFORMAT_XRGB2101010 };
    pub const packed_xbgr_2_10_10_10 = Format{ .value = C.SDL_PIXELFORMAT_XBGR2101010 };
    pub const packed_argb_2_10_10_10 = Format{ .value = C.SDL_PIXELFORMAT_ARGB2101010 };
    pub const packed_abgr_2_10_10_10 = Format{ .value = C.SDL_PIXELFORMAT_ABGR2101010 };
    pub const array_rgb_48 = Format{ .value = C.SDL_PIXELFORMAT_RGB48 };
    pub const array_bgr_48 = Format{ .value = C.SDL_PIXELFORMAT_BGR48 };
    pub const array_rgba_64 = Format{ .value = C.SDL_PIXELFORMAT_RGBA64 };
    pub const array_argb_64 = Format{ .value = C.SDL_PIXELFORMAT_ARGB64 };
    pub const array_bgra_64 = Format{ .value = C.SDL_PIXELFORMAT_BGRA64 };
    pub const array_abgr_64 = Format{ .value = C.SDL_PIXELFORMAT_ABGR64 };
    pub const array_rgb_48_float = Format{ .value = C.SDL_PIXELFORMAT_RGB48_FLOAT };
    pub const array_bgr_48_float = Format{ .value = C.SDL_PIXELFORMAT_BGR48_FLOAT };
    pub const array_rgba_64_float = Format{ .value = C.SDL_PIXELFORMAT_RGBA64_FLOAT };
    pub const array_argb_64_float = Format{ .value = C.SDL_PIXELFORMAT_ARGB64_FLOAT };
    pub const array_bgra_64_float = Format{ .value = C.SDL_PIXELFORMAT_BGRA64_FLOAT };
    pub const array_abgr_64_float = Format{ .value = C.SDL_PIXELFORMAT_ABGR64_FLOAT };
    pub const fourcc_yv12 = Format{ .value = C.SDL_PIXELFORMAT_YV12 };
    pub const fourcc_iyuv = Format{ .value = C.SDL_PIXELFORMAT_IYUV };
    pub const fourcc_yuy2 = Format{ .value = C.SDL_PIXELFORMAT_YUY2 };
    pub const fourcc_uyvy = Format{ .value = C.SDL_PIXELFORMAT_UYVY };
    pub const fourcc_yvyu = Format{ .value = C.SDL_PIXELFORMAT_YVYU };
    pub const fourcc_nv12 = Format{ .value = C.SDL_PIXELFORMAT_NV12 };
    pub const fourcc_nv21 = Format{ .value = C.SDL_PIXELFORMAT_NV21 };
    pub const fourcc_p010 = Format{ .value = C.SDL_PIXELFORMAT_P010 };
    pub const fourcc_oes = Format{ .value = C.SDL_PIXELFORMAT_EXTERNAL_OES };
    pub const array_rgba_32 = Format{ .value = C.SDL_PIXELFORMAT_RGBA32 };
    pub const array_argb_32 = Format{ .value = C.SDL_PIXELFORMAT_ARGB32 };
    pub const array_bgra_32 = Format{ .value = C.SDL_PIXELFORMAT_BGRA32 };
    pub const array_abgr_32 = Format{ .value = C.SDL_PIXELFORMAT_ABGR32 };
    pub const array_rgbx_32 = Format{ .value = C.SDL_PIXELFORMAT_RGBX32 };
    pub const array_xrgb_32 = Format{ .value = C.SDL_PIXELFORMAT_XRGB32 };
    pub const array_bgrx_32 = Format{ .value = C.SDL_PIXELFORMAT_BGRX32 };
    pub const array_xbgr_32 = Format{ .value = C.SDL_PIXELFORMAT_XBGR32 };

    /// Define a format using 4 characters (Ex: YV12).
    pub fn define4CC(
        a: u8,
        b: u8,
        c: u8,
        d: u8,
    ) Format {
        const ret = C.SDL_DEFINE_PIXELFOURCC(
            @intCast(a),
            @intCast(b),
            @intCast(c),
            @intCast(d),
        );
        return Format{ .value = ret };
    }

    /// Define a pixel format.
    pub fn define(
        pixel_type: Type,
        order: OrderType(pixel_type),
        layout: Layout,
        bits: u8,
        bytes: u8,
    ) Format {
        const ret = C.SDL_DEFINE_PIXELFORMAT(
            @intFromEnum(pixel_type),
            @intFromEnum(order),
            @intFromEnum(layout),
            @intCast(bits),
            @intCast(bytes),
        );
        return Format{ .value = ret };
    }

    /// If format was created by `define` rather than `define4CC`.
    pub fn getFlag(
        self: Format,
    ) bool {
        const ret = C.SDL_PIXELFLAG(
            self.value,
        );
        return ret != 0;
    }

    /// Get the type component of the format.
    pub fn getType(
        self: Format,
    ) ?Type {
        const ret = C.SDL_PIXELTYPE(
            self.value,
        );
        if (ret == C.SDL_PIXELTYPE_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the order component of the format.
    pub fn getOrder(
        self: Format,
    ) c_int {
        const ret = C.SDL_PIXELORDER(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the typed order component of the format. Do not run this on formats with an invalid type!
    pub fn getOrderTyped(
        self: Format,
    ) OrderType(self.getType().?) {
        const ret = C.SDL_PIXELORDER(
            self.value,
        );
        return @enumFromInt(ret);
    }

    /// Get the layout component of the format.
    pub fn getLayout(
        self: Format,
    ) Layout {
        const ret = C.SDL_PACKEDLAYOUT(
            self.value,
        );
        return @enumFromInt(ret);
    }

    /// Get the bits per pixel of the format.
    pub fn getBitsPerPixel(
        self: Format,
    ) u8 {
        const ret = C.SDL_BITSPERPIXEL(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the bytes per pixel of the format.
    pub fn getBytesPerPixel(
        self: Format,
    ) u8 {
        const ret = C.SDL_BYTESPERPIXEL(
            self.value,
        );
        return @intCast(ret);
    }

    /// If the format is indexed.
    pub fn isIndexed(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_INDEXED(
            self.value,
        );
        return ret;
    }

    /// If the format is packed.
    pub fn isPacked(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_PACKED(
            self.value,
        );
        return ret;
    }

    /// If the format is array.
    pub fn isArray(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_ARRAY(
            self.value,
        );
        return ret;
    }

    /// If the format has alpha.
    pub fn hasAlpha(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_ALPHA(
            self.value,
        );
        return ret;
    }

    /// If the format is 10-bit.
    pub fn is10Bit(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_10BIT(
            self.value,
        );
        return ret;
    }

    /// If the format is floating point.
    pub fn isFloat(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_FLOAT(
            self.value,
        );
        return ret;
    }

    /// If the format is 4CC.
    pub fn is4CC(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_FOURCC(
            self.value,
        );
        return ret;
    }

    /// Get the human readable name of a pixel format.
    pub fn getName(
        self: Format,
    ) ?[]const u8 {
        const ret = C.SDL_GetPixelFormatName(
            self.value,
        );
        const converted_ret = std.mem.span(ret);
        if (std.mem.eql(u8, converted_ret, "SDL_PIXELFORMAT_UNKNOWN"))
            return null;
        return converted_ret;
    }

    /// Convert one of the enumerated pixel formats to a bpp value and RGBA masks.
    pub fn getMasks(
        self: Format,
    ) !struct { bpp: u8, r_mask: u32, g_mask: u32, b_mask: u32, a_mask: u32 } {
        var bpp: c_int = undefined;
        var r_mask: u32 = undefined;
        var g_mask: u32 = undefined;
        var b_mask: u32 = undefined;
        var a_mask: u32 = undefined;
        const ret = C.SDL_GetMasksForPixelFormat(
            self.value,
            &bpp,
            &r_mask,
            &g_mask,
            &b_mask,
            &a_mask,
        );
        if (ret == false)
            return null;
        return .{ .bpp = @intCast(bpp), .r_mask = r_mask, .g_mask = g_mask, .b_mask = b_mask, .a_mask = a_mask };
    }

    /// Convert a bpp value and RGBA masks to an enumerated pixel format.
    pub fn fromMasks(
        bpp: u8,
        r_mask: u32,
        g_mask: u32,
        b_mask: u32,
        a_mask: u32,
    ) ?Format {
        const ret = C.SDL_GetPixelFormatForMasks(
            @intCast(bpp),
            @intCast(r_mask),
            @intCast(g_mask),
            @intCast(b_mask),
            @intCast(a_mask),
        );
        if (ret == C.SDL_PIXELFORMAT_UNKNOWN)
            return null;
        return Format{ .value = ret };
    }

    /// Create an SDL_PixelFormatDetails structure corresponding to a pixel format.
    pub fn getDetails(
        self: Format,
    ) !FormatDetails {
        const ret = C.SDL_GetPixelFormatDetails(
            self.value,
        );
        if (ret == null)
            return null;
        return FormatDetails.fromSdl(ret.*);
    }
};

/// A set of indexed colors representing a palette.
pub const Palette = struct {
    value: *C.SDL_Palette,

    /// Create a palette structure with the specified number of color entries.
    pub fn init(
        num_colors: u32,
    ) !Palette {
        const ret = C.SDL_CreatePalette(
            @intCast(num_colors),
        );
        if (ret == null)
            return null;
        return Palette{ .value = ret };
    }

    /// Set a range of colors in a palette.
    pub fn setColors(
        self: Palette,
        colors: []const Color,
        first_color: usize,
    ) !void {
        const ret = C.SDL_SetPaletteColors(
            self.value,
            colors.ptr,
            @intCast(first_color),
            @intCast(colors.len),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Free a palette created earlier.
    pub fn deinit(
        self: Palette,
    ) void {
        const ret = C.SDL_DestroyPalette(
            self.value,
        );
        _ = ret;
    }
};

/// Details about the format of a pixel.
pub const FormatDetails = struct {
    format: ?Format,
    bits_per_pixel: u8,
    bytes_per_pixel: u8,
    r_mask: u32,
    g_mask: u32,
    b_mask: u32,
    r_bits: u8,
    g_bits: u8,
    b_bits: u8,
    a_bits: u8,
    r_shift: u8,
    g_shift: u8,
    b_shift: u8,
    a_shift: u8,

    /// Convert from an SDL value.
    pub fn fromSdl(data: C.SDL_PixelFormatDetails) FormatDetails {
        return .{
            .format = if (data.format == C.SDL_PIXELFORMAT_UNKNOWN) null else Format{ .value = data.format },
            .bits_per_pixel = @intCast(data.bits_per_pixel),
            .bytes_per_pixel = @intCast(data.bytes_per_pixel),
            .r_mask = @intCast(data.Rmask),
            .g_mask = @intCast(data.Gmask),
            .b_mask = @intCast(data.Bmask),
            .r_bits = @intCast(data.Rbits),
            .g_bits = @intCast(data.Gbits),
            .b_bits = @intCast(data.Bbits),
            .a_bits = @intCast(data.Abits),
            .r_shift = @intCast(data.Rshift),
            .g_shift = @intCast(data.Gshift),
            .b_shift = @intCast(data.Bshift),
            .a_shift = @intCast(data.Ashift),
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: FormatDetails) C.SDL_PixelFormatDetails {
        return .{
            .format = if (self.format == null) C.SDL_PIXELFORMAT_UNKNOWN else self.format,
            .bits_per_pixel = @intCast(self.bits_per_pixel),
            .bytes_per_pixel = @intCast(self.bytes_per_pixel),
            .Rmask = @intCast(self.Rmask),
            .Gmask = @intCast(self.Gmask),
            .Bmask = @intCast(self.Bmask),
            .Rbits = @intCast(self.Rbits),
            .Gbits = @intCast(self.Gbits),
            .Bbits = @intCast(self.Bbits),
            .Abits = @intCast(self.Abits),
            .Rshift = @intCast(self.Rshift),
            .Gshift = @intCast(self.Gshift),
            .Bshift = @intCast(self.Bshift),
            .Ashift = @intCast(self.Ashift),
        };
    }

    /// Map an RGB triple to an opaque pixel value for a given pixel format.
    pub fn mapRgb(
        self: FormatDetails,
        palette: ?Palette,
        r: u8,
        g: u8,
        b: u8,
    ) u32 {
        const self_sdl: C.SDL_PixelFormatDetails = self.toSdl();
        const ret = C.SDL_MapRGB(
            &self_sdl,
            if (palette == null) null else palette.value,
            @intCast(r),
            @intCast(g),
            @intCast(b),
        );
        return @intCast(ret);
    }

    /// Map an RGBA quadruple to a transparent pixel value for a given pixel format.
    pub fn mapRgba(
        self: FormatDetails,
        palette: ?Palette,
        r: u8,
        g: u8,
        b: u8,
        a: u8,
    ) u32 {
        const self_sdl: C.SDL_PixelFormatDetails = self.toSdl();
        const ret = C.SDL_MapRGBA(
            &self_sdl,
            if (palette == null) null else palette.value,
            @intCast(r),
            @intCast(g),
            @intCast(b),
            @intCast(a),
        );
        return @intCast(ret);
    }

    /// Get RGB values from a pixel in the specified format.
    pub fn getRgb(
        self: FormatDetails,
        pixel: u32,
        palette: ?Palette,
    ) struct { r: u8, g: u8, b: u8 } {
        const self_sdl: C.SDL_PixelFormatDetails = self.toSdl();
        var r: u8 = undefined;
        var g: u8 = undefined;
        var b: u8 = undefined;
        const ret = C.SDL_GetRGB(
            @intCast(pixel),
            &self_sdl,
            if (palette == null) null else palette.value,
            &r,
            &g,
            &b,
        );
        _ = ret;
        return .{ .r = r, .g = g, .b = b };
    }

    /// Get RGBA values from a pixel in the specified format.
    pub fn getRgba(
        self: FormatDetails,
        pixel: u32,
        palette: ?Palette,
    ) struct { r: u8, g: u8, b: u8, a: u8 } {
        const self_sdl: C.SDL_PixelFormatDetails = self.toSdl();
        var r: u8 = undefined;
        var g: u8 = undefined;
        var b: u8 = undefined;
        var a: u8 = undefined;
        const ret = C.SDL_GetRGBA(
            @intCast(pixel),
            &self_sdl,
            if (palette == null) null else palette.value,
            &r,
            &g,
            &b,
            &a,
        );
        _ = ret;
        return .{ .r = r, .g = g, .b = b, .a = a };
    }
};

/// Get the order type of a pixel type.
fn OrderType(pixel_type: Type) type {
    return switch (pixel_type) {
        .Index1, .Index2, .Index4, .Index8 => IndexOrder,
        .Packed8, .Packed16, .Packed32 => PackedOrder,
        .ArrayU8, .ArrayU16, .ArrayU32, .ArrayF16, .ArrayF32 => ArrayOrder,
    };
}

/// A fully opaque 8-bit alpha value.
pub const alpha_opaque: u8 = 255;

/// A fully transparent 8-bit alpha value.
pub const alpha_transparent: u8 = 0;

/// A fully opaque float alpha value.
pub const alpha_opaque_float: f32 = 1;

/// A fully transparent float alpha value.
pub const alpha_transparent_float: f32 = 0;

/// A structure that represents a color as RGBA components.
pub const Color = C.SDL_Color;

/// The bits of this structure can be directly reinterpreted as a float-packed.
pub const FColor = C.SDL_FColor;
