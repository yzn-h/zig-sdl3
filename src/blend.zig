// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Factor to use for a blend operation.
pub const Factor = enum(c_uint) {
	/// (0, 0, 0, 0)
	Zero = C.SDL_BLENDFACTOR_ZERO,
	/// (1, 1, 1, 1)
	One = C.SDL_BLENDFACTOR_ONE,
	/// (r, g, b, a)
	SrcColor = C.SDL_BLENDFACTOR_SRC_COLOR,
	/// (1-r, 1-g, 1-b, 1-a)
	OneMinusSrcColor = C.SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR,
	/// (a, a, a, a)
	SrcAlpha = C.SDL_BLENDFACTOR_SRC_ALPHA,
	/// (1-a, 1-a, 1-a, 1-a)
	OneMinusSrcAlpha = C.SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
	/// (r, g, b, a)
	DstColor = C.SDL_BLENDFACTOR_DST_COLOR,
	/// (1-r, 1-g, 1-b, 1-a)
	OneMinusDstColor = C.SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR,
	/// (a, a, a, a)
	DstAlpha = C.SDL_BLENDFACTOR_DST_ALPHA,
	/// (1-a, 1-a, 1-a, 1-a)
	OneMinusDstAlpha = C.SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA,
};

/// Blend operation.
pub const Operation = enum(c_uint) {
	/// Dst + Src.
	Add = C.SDL_BLENDOPERATION_ADD,
	/// Src - Dst.
	Sub = C.SDL_BLENDOPERATION_SUBTRACT,
	/// Dst - Src.
	RevSub = C.SDL_BLENDOPERATION_REV_SUBTRACT,
	/// Min(Dst, Src).
	Min = C.SDL_BLENDOPERATION_MINIMUM,
	/// Max(Dst, Src).
	Max = C.SDL_BLENDOPERATION_MAXIMUM,
};

/// Mode for blending colors.
pub const Mode = struct {
	value: C.SDL_BlendMode,
	/// Dst = Src.
	pub const None = Mode{ .value = C.SDL_BLENDMODE_NONE };
	/// DstRGB = (SrcRGB * SrcA) + (DstRGB * (1-SrcA)), DstA = SrcA + (DstA * (1-SrcA)).
	pub const Blend = Mode{ .value = C.SDL_BLENDMODE_BLEND };
	/// DstRGBA = SrcRGBA + (DstRGBA * (1-SrcA)).
	pub const BlendPremultiplied = Mode{ .value = C.SDL_BLENDMODE_BLEND_PREMULTIPLIED };
	/// DstRGB = (SrcRGB * SrcA) + DstRGB, DstA = DstA.
	pub const Add = Mode{ .value = C.SDL_BLENDMODE_ADD };
	/// DstRGB = SrcRGB + DstRGB, DstA = DstA.
	pub const AddPremultiplied = Mode{ .value = C.SDL_BLENDMODE_ADD_PREMULTIPLIED };
	/// DstRGB = SrcRGB * DstRGB, DstA = DstA.
	pub const Mod = Mode{ .value = C.SDL_BLENDMODE_MOD };
	/// DstRGB = (SrcRGB * DstRGB) + (DstRGB * (1-SrcA)), DstA = DstA.
	pub const Mul = Mode{ .value = C.SDL_BLENDMODE_MUL };

	/// Create a custom blend mode. The source is the pixels we are writing to the destination render target.
	pub fn custom(
		srcRgb: Factor,
		dstRgb: Factor,
		rgbOp: Operation,
		srcAlpha: Factor,
		dstAlpha: Factor,
		alphaOp: Operation,
	) ?Mode {
		const ret = C.SDL_ComposeCustomBlendMode(
			@intFromEnum(srcRgb),
			@intFromEnum(dstRgb),
			@intFromEnum(rgbOp),
			@intFromEnum(srcAlpha),
			@intFromEnum(dstAlpha),
			@intFromEnum(alphaOp),
		);
		if (ret == C.SDL_BLENDMODE_INVALID)
			return null;
		return Mode{ .value = ret };
	}
};
