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

/// Pixel format.
pub const Format = struct {
	value: c_uint,
	/// null
	pub const Index1Lsb = Format{ .value = C.SDL_PIXELFORMAT_INDEX1LSB };

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
};

/// Get the order type of a pixel type.
fn OrderType(pixel_type: Type) type {
    return switch (pixel_type) {
        .Index1, .Index2, .Index4, .Index8 => IndexOrder,
        .Packed8, .Packed16, .Packed32 => PackedOrder,
        .ArrayU8, .ArrayU16, .ArrayU32, .ArrayF16, .ArrayF32 => ArrayOrder,
    };
}
