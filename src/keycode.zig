// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// The SDL virtual key representation.
pub const Keycode = struct {
	value: C.SDL_Keycode,
	pub const return_key = Keycode{ .value = C.SDLK_RETURN };
	pub const escape = Keycode{ .value = C.SDLK_ESCAPE };
	pub const backspace = Keycode{ .value = C.SDLK_BACKSPACE };
	pub const tab = Keycode{ .value = C.SDLK_TAB };
	pub const space = Keycode{ .value = C.SDLK_SPACE };
	pub const exclaim = Keycode{ .value = C.SDLK_EXCLAIM };
	pub const dblapostrophe = Keycode{ .value = C.SDLK_DBLAPOSTROPHE };
	pub const hash = Keycode{ .value = C.SDLK_HASH };
	pub const dollar = Keycode{ .value = C.SDLK_DOLLAR };
	pub const percent = Keycode{ .value = C.SDLK_PERCENT };
	pub const ampersand = Keycode{ .value = C.SDLK_AMPERSAND };
	pub const apostrophe = Keycode{ .value = C.SDLK_APOSTROPHE };
	pub const leftparen = Keycode{ .value = C.SDLK_LEFTPAREN };
	pub const rightparen = Keycode{ .value = C.SDLK_RIGHTPAREN };
	pub const asterisk = Keycode{ .value = C.SDLK_ASTERISK };
	pub const plus = Keycode{ .value = C.SDLK_PLUS };
	pub const comma = Keycode{ .value = C.SDLK_COMMA };
	pub const minus = Keycode{ .value = C.SDLK_MINUS };
	pub const period = Keycode{ .value = C.SDLK_PERIOD };
	pub const slash = Keycode{ .value = C.SDLK_SLASH };
	pub const zero = Keycode{ .value = C.SDLK_0 };
	pub const one = Keycode{ .value = C.SDLK_1 };
	pub const two = Keycode{ .value = C.SDLK_2 };
	pub const three = Keycode{ .value = C.SDLK_3 };
	pub const four = Keycode{ .value = C.SDLK_4 };
	pub const five = Keycode{ .value = C.SDLK_5 };
	pub const six = Keycode{ .value = C.SDLK_6 };
	pub const seven = Keycode{ .value = C.SDLK_7 };
	pub const eight = Keycode{ .value = C.SDLK_8 };
	pub const nine = Keycode{ .value = C.SDLK_9 };
	pub const colon = Keycode{ .value = C.SDLK_COLON };
	pub const semicolon = Keycode{ .value = C.SDLK_SEMICOLON };
	pub const less = Keycode{ .value = C.SDLK_LESS };
	pub const equals = Keycode{ .value = C.SDLK_EQUALS };
	pub const greater = Keycode{ .value = C.SDLK_GREATER };
	pub const question = Keycode{ .value = C.SDLK_QUESTION };
	pub const at = Keycode{ .value = C.SDLK_AT };
	pub const leftbracket = Keycode{ .value = C.SDLK_LEFTBRACKET };
	pub const backslash = Keycode{ .value = C.SDLK_BACKSLASH };
	pub const rightbracket = Keycode{ .value = C.SDLK_RIGHTBRACKET };
	pub const caret = Keycode{ .value = C.SDLK_CARET };
	pub const underscore = Keycode{ .value = C.SDLK_UNDERSCORE };
	pub const grave = Keycode{ .value = C.SDLK_GRAVE };
	pub const a = Keycode{ .value = C.SDLK_A };
	pub const b = Keycode{ .value = C.SDLK_B };
	pub const c = Keycode{ .value = C.SDLK_C };
	pub const d = Keycode{ .value = C.SDLK_D };
	pub const e = Keycode{ .value = C.SDLK_E };
	pub const f = Keycode{ .value = C.SDLK_F };
	pub const g = Keycode{ .value = C.SDLK_G };
	pub const h = Keycode{ .value = C.SDLK_H };
	pub const i = Keycode{ .value = C.SDLK_I };
	pub const j = Keycode{ .value = C.SDLK_J };
	pub const k = Keycode{ .value = C.SDLK_K };
	pub const l = Keycode{ .value = C.SDLK_L };
	pub const m = Keycode{ .value = C.SDLK_M };
	pub const n = Keycode{ .value = C.SDLK_N };
	pub const o = Keycode{ .value = C.SDLK_O };
	pub const p = Keycode{ .value = C.SDLK_P };
	pub const q = Keycode{ .value = C.SDLK_Q };
	pub const r = Keycode{ .value = C.SDLK_R };
	pub const s = Keycode{ .value = C.SDLK_S };
	pub const t = Keycode{ .value = C.SDLK_T };
	pub const u = Keycode{ .value = C.SDLK_U };
	pub const v = Keycode{ .value = C.SDLK_V };
	pub const w = Keycode{ .value = C.SDLK_W };
	pub const x = Keycode{ .value = C.SDLK_X };
	pub const y = Keycode{ .value = C.SDLK_Y };
	pub const z = Keycode{ .value = C.SDLK_Z };
	pub const leftbrace = Keycode{ .value = C.SDLK_LEFTBRACE };
	pub const pipe = Keycode{ .value = C.SDLK_PIPE };
	pub const rightbrace = Keycode{ .value = C.SDLK_RIGHTBRACE };
	pub const tilde = Keycode{ .value = C.SDLK_TILDE };
	pub const delete = Keycode{ .value = C.SDLK_DELETE };
	pub const plusminus = Keycode{ .value = C.SDLK_PLUSMINUS };
	pub const capslock = Keycode{ .value = C.SDLK_CAPSLOCK };
	pub const func1 = Keycode{ .value = C.SDLK_F1 };
	pub const func2 = Keycode{ .value = C.SDLK_F2 };
	pub const func3 = Keycode{ .value = C.SDLK_F3 };
	pub const func4 = Keycode{ .value = C.SDLK_F4 };
	pub const func5 = Keycode{ .value = C.SDLK_F5 };
	pub const func6 = Keycode{ .value = C.SDLK_F6 };
	pub const func7 = Keycode{ .value = C.SDLK_F7 };
	pub const func8 = Keycode{ .value = C.SDLK_F8 };
	pub const func9 = Keycode{ .value = C.SDLK_F9 };
	pub const func10 = Keycode{ .value = C.SDLK_F10 };
	pub const func11 = Keycode{ .value = C.SDLK_F11 };
	pub const func12 = Keycode{ .value = C.SDLK_F12 };
	pub const printscreen = Keycode{ .value = C.SDLK_PRINTSCREEN };
	pub const scrolllock = Keycode{ .value = C.SDLK_SCROLLLOCK };
	pub const pause = Keycode{ .value = C.SDLK_PAUSE };
	pub const insert = Keycode{ .value = C.SDLK_INSERT };
	pub const home = Keycode{ .value = C.SDLK_HOME };
	pub const pageup = Keycode{ .value = C.SDLK_PAGEUP };
	pub const end = Keycode{ .value = C.SDLK_END };
	pub const pagedown = Keycode{ .value = C.SDLK_PAGEDOWN };
	pub const right = Keycode{ .value = C.SDLK_RIGHT };
	pub const left = Keycode{ .value = C.SDLK_LEFT };
	pub const down = Keycode{ .value = C.SDLK_DOWN };
	pub const up = Keycode{ .value = C.SDLK_UP };
	pub const numlockclear = Keycode{ .value = C.SDLK_NUMLOCKCLEAR };
	pub const kp_divide = Keycode{ .value = C.SDLK_KP_DIVIDE };
	pub const kp_multiply = Keycode{ .value = C.SDLK_KP_MULTIPLY };
	pub const kp_minus = Keycode{ .value = C.SDLK_KP_MINUS };
	pub const kp_plus = Keycode{ .value = C.SDLK_KP_PLUS };
	pub const kp_enter = Keycode{ .value = C.SDLK_KP_ENTER };
	pub const kp_1 = Keycode{ .value = C.SDLK_KP_1 };
	pub const kp_2 = Keycode{ .value = C.SDLK_KP_2 };
	pub const kp_3 = Keycode{ .value = C.SDLK_KP_3 };
	pub const kp_4 = Keycode{ .value = C.SDLK_KP_4 };
	pub const kp_5 = Keycode{ .value = C.SDLK_KP_5 };
	pub const kp_6 = Keycode{ .value = C.SDLK_KP_6 };
	pub const kp_7 = Keycode{ .value = C.SDLK_KP_7 };
	pub const kp_8 = Keycode{ .value = C.SDLK_KP_8 };
	pub const kp_9 = Keycode{ .value = C.SDLK_KP_9 };
	pub const kp_0 = Keycode{ .value = C.SDLK_KP_0 };
	pub const kp_period = Keycode{ .value = C.SDLK_KP_PERIOD };
	pub const application = Keycode{ .value = C.SDLK_APPLICATION };
	pub const power = Keycode{ .value = C.SDLK_POWER };
	pub const kp_equals = Keycode{ .value = C.SDLK_KP_EQUALS };
	pub const func13 = Keycode{ .value = C.SDLK_F13 };
	pub const func14 = Keycode{ .value = C.SDLK_F14 };
	pub const func15 = Keycode{ .value = C.SDLK_F15 };
	pub const func16 = Keycode{ .value = C.SDLK_F16 };
	pub const func17 = Keycode{ .value = C.SDLK_F17 };
	pub const func18 = Keycode{ .value = C.SDLK_F18 };
	pub const func19 = Keycode{ .value = C.SDLK_F19 };
	pub const func20 = Keycode{ .value = C.SDLK_F20 };
	pub const func21 = Keycode{ .value = C.SDLK_F21 };
	pub const func22 = Keycode{ .value = C.SDLK_F22 };
	pub const func23 = Keycode{ .value = C.SDLK_F23 };
	pub const func24 = Keycode{ .value = C.SDLK_F24 };
	pub const execute = Keycode{ .value = C.SDLK_EXECUTE };
	pub const help = Keycode{ .value = C.SDLK_HELP };
	pub const menu = Keycode{ .value = C.SDLK_MENU };
	pub const select = Keycode{ .value = C.SDLK_SELECT };
	pub const stop = Keycode{ .value = C.SDLK_STOP };
	pub const again = Keycode{ .value = C.SDLK_AGAIN };
	pub const undo = Keycode{ .value = C.SDLK_UNDO };
	pub const cut = Keycode{ .value = C.SDLK_CUT };
	pub const copy = Keycode{ .value = C.SDLK_COPY };
	pub const paste = Keycode{ .value = C.SDLK_PASTE };
	pub const find = Keycode{ .value = C.SDLK_FIND };
	pub const mute = Keycode{ .value = C.SDLK_MUTE };
	pub const volumeup = Keycode{ .value = C.SDLK_VOLUMEUP };
	pub const volumedown = Keycode{ .value = C.SDLK_VOLUMEDOWN };
	pub const kp_comma = Keycode{ .value = C.SDLK_KP_COMMA };
	pub const kp_equalsas400 = Keycode{ .value = C.SDLK_KP_EQUALSAS400 };
	pub const alterase = Keycode{ .value = C.SDLK_ALTERASE };
	pub const sysreq = Keycode{ .value = C.SDLK_SYSREQ };
	pub const cancel = Keycode{ .value = C.SDLK_CANCEL };
	pub const clear = Keycode{ .value = C.SDLK_CLEAR };
	pub const prior = Keycode{ .value = C.SDLK_PRIOR };
	pub const return_key2 = Keycode{ .value = C.SDLK_RETURN2 };
	pub const separator = Keycode{ .value = C.SDLK_SEPARATOR };
	pub const out = Keycode{ .value = C.SDLK_OUT };
	pub const oper = Keycode{ .value = C.SDLK_OPER };
	pub const clearagain = Keycode{ .value = C.SDLK_CLEARAGAIN };
	pub const crsel = Keycode{ .value = C.SDLK_CRSEL };
	pub const exsel = Keycode{ .value = C.SDLK_EXSEL };
	pub const kp_00 = Keycode{ .value = C.SDLK_KP_00 };
	pub const kp_000 = Keycode{ .value = C.SDLK_KP_000 };
	pub const thousandsseparator = Keycode{ .value = C.SDLK_THOUSANDSSEPARATOR };
	pub const decimalseparator = Keycode{ .value = C.SDLK_DECIMALSEPARATOR };
	pub const currencyunit = Keycode{ .value = C.SDLK_CURRENCYUNIT };
	pub const currencysubunit = Keycode{ .value = C.SDLK_CURRENCYSUBUNIT };
	pub const kp_leftparen = Keycode{ .value = C.SDLK_KP_LEFTPAREN };
	pub const kp_rightparen = Keycode{ .value = C.SDLK_KP_RIGHTPAREN };
	pub const kp_leftbrace = Keycode{ .value = C.SDLK_KP_LEFTBRACE };
	pub const kp_rightbrace = Keycode{ .value = C.SDLK_KP_RIGHTBRACE };
	pub const kp_tab = Keycode{ .value = C.SDLK_KP_TAB };
	pub const kp_backspace = Keycode{ .value = C.SDLK_KP_BACKSPACE };
	pub const kp_a = Keycode{ .value = C.SDLK_KP_A };
	pub const kp_b = Keycode{ .value = C.SDLK_KP_B };
	pub const kp_c = Keycode{ .value = C.SDLK_KP_C };
	pub const kp_d = Keycode{ .value = C.SDLK_KP_D };
	pub const kp_e = Keycode{ .value = C.SDLK_KP_E };
	pub const kp_f = Keycode{ .value = C.SDLK_KP_F };
	pub const kp_xor = Keycode{ .value = C.SDLK_KP_XOR };
	pub const kp_power = Keycode{ .value = C.SDLK_KP_POWER };
	pub const kp_percent = Keycode{ .value = C.SDLK_KP_PERCENT };
	pub const kp_less = Keycode{ .value = C.SDLK_KP_LESS };
	pub const kp_greater = Keycode{ .value = C.SDLK_KP_GREATER };
	pub const kp_ampersand = Keycode{ .value = C.SDLK_KP_AMPERSAND };
	pub const kp_dblampersand = Keycode{ .value = C.SDLK_KP_DBLAMPERSAND };
	pub const kp_verticalbar = Keycode{ .value = C.SDLK_KP_VERTICALBAR };
	pub const kp_dblverticalbar = Keycode{ .value = C.SDLK_KP_DBLVERTICALBAR };
	pub const kp_colon = Keycode{ .value = C.SDLK_KP_COLON };
	pub const kp_hash = Keycode{ .value = C.SDLK_KP_HASH };
	pub const kp_space = Keycode{ .value = C.SDLK_KP_SPACE };
	pub const kp_at = Keycode{ .value = C.SDLK_KP_AT };
	pub const kp_exclam = Keycode{ .value = C.SDLK_KP_EXCLAM };
	pub const kp_memstore = Keycode{ .value = C.SDLK_KP_MEMSTORE };
	pub const kp_memrecall = Keycode{ .value = C.SDLK_KP_MEMRECALL };
	pub const kp_memclear = Keycode{ .value = C.SDLK_KP_MEMCLEAR };
	pub const kp_memadd = Keycode{ .value = C.SDLK_KP_MEMADD };
	pub const kp_memsubtract = Keycode{ .value = C.SDLK_KP_MEMSUBTRACT };
	pub const kp_memmultiply = Keycode{ .value = C.SDLK_KP_MEMMULTIPLY };
	pub const kp_memdivide = Keycode{ .value = C.SDLK_KP_MEMDIVIDE };
	pub const kp_plusminus = Keycode{ .value = C.SDLK_KP_PLUSMINUS };
	pub const kp_clear = Keycode{ .value = C.SDLK_KP_CLEAR };
	pub const kp_clearentry = Keycode{ .value = C.SDLK_KP_CLEARENTRY };
	pub const kp_binary = Keycode{ .value = C.SDLK_KP_BINARY };
	pub const kp_octal = Keycode{ .value = C.SDLK_KP_OCTAL };
	pub const kp_decimal = Keycode{ .value = C.SDLK_KP_DECIMAL };
	pub const kp_hexadecimal = Keycode{ .value = C.SDLK_KP_HEXADECIMAL };
	pub const lctrl = Keycode{ .value = C.SDLK_LCTRL };
	pub const lshift = Keycode{ .value = C.SDLK_LSHIFT };
	pub const lalt = Keycode{ .value = C.SDLK_LALT };
	pub const lgui = Keycode{ .value = C.SDLK_LGUI };
	pub const rctrl = Keycode{ .value = C.SDLK_RCTRL };
	pub const rshift = Keycode{ .value = C.SDLK_RSHIFT };
	pub const ralt = Keycode{ .value = C.SDLK_RALT };
	pub const rgui = Keycode{ .value = C.SDLK_RGUI };
	pub const mode = Keycode{ .value = C.SDLK_MODE };
	pub const sleep = Keycode{ .value = C.SDLK_SLEEP };
	pub const wake = Keycode{ .value = C.SDLK_WAKE };
	pub const channel_increment = Keycode{ .value = C.SDLK_CHANNEL_INCREMENT };
	pub const channel_decrement = Keycode{ .value = C.SDLK_CHANNEL_DECREMENT };
	pub const media_play = Keycode{ .value = C.SDLK_MEDIA_PLAY };
	pub const media_pause = Keycode{ .value = C.SDLK_MEDIA_PAUSE };
	pub const media_record = Keycode{ .value = C.SDLK_MEDIA_RECORD };
	pub const media_fast_forward = Keycode{ .value = C.SDLK_MEDIA_FAST_FORWARD };
	pub const media_rewind = Keycode{ .value = C.SDLK_MEDIA_REWIND };
	pub const media_next_track = Keycode{ .value = C.SDLK_MEDIA_NEXT_TRACK };
	pub const media_previous_track = Keycode{ .value = C.SDLK_MEDIA_PREVIOUS_TRACK };
	pub const media_stop = Keycode{ .value = C.SDLK_MEDIA_STOP };
	pub const media_eject = Keycode{ .value = C.SDLK_MEDIA_EJECT };
	pub const media_play_pause = Keycode{ .value = C.SDLK_MEDIA_PLAY_PAUSE };
	pub const media_select = Keycode{ .value = C.SDLK_MEDIA_SELECT };
	pub const ac_new = Keycode{ .value = C.SDLK_AC_NEW };
	pub const ac_open = Keycode{ .value = C.SDLK_AC_OPEN };
	pub const ac_close = Keycode{ .value = C.SDLK_AC_CLOSE };
	pub const ac_exit = Keycode{ .value = C.SDLK_AC_EXIT };
	pub const ac_save = Keycode{ .value = C.SDLK_AC_SAVE };
	pub const ac_print = Keycode{ .value = C.SDLK_AC_PRINT };
	pub const ac_properties = Keycode{ .value = C.SDLK_AC_PROPERTIES };
	pub const ac_search = Keycode{ .value = C.SDLK_AC_SEARCH };
	pub const ac_home = Keycode{ .value = C.SDLK_AC_HOME };
	pub const ac_back = Keycode{ .value = C.SDLK_AC_BACK };
	pub const ac_forward = Keycode{ .value = C.SDLK_AC_FORWARD };
	pub const ac_stop = Keycode{ .value = C.SDLK_AC_STOP };
	pub const ac_refresh = Keycode{ .value = C.SDLK_AC_REFRESH };
	pub const ac_bookmarks = Keycode{ .value = C.SDLK_AC_BOOKMARKS };
	pub const softleft = Keycode{ .value = C.SDLK_SOFTLEFT };
	pub const softright = Keycode{ .value = C.SDLK_SOFTRIGHT };
	pub const call = Keycode{ .value = C.SDLK_CALL };
	pub const endcall = Keycode{ .value = C.SDLK_ENDCALL };

	/// Create a keycode from a scancode.
	pub fn fromKeycode(
		code: scancode.Scancode,
	) Keycode {
		const ret = C.SDL_SCANCODE_TO_KEYCODE(
			code.value,
		);
		return Keycode{ .value = ret };
	}
};

/// Valid key modifiers.
pub const KeyModifier = struct {
	LeftShift: bool = false,
	RightShift: bool = false,
	LeftControl: bool = false,
	RightControl: bool = false,
	LeftAlt: bool = false,
	RightAlt: bool = false,
	LeftGui: bool = false,
	RightGui: bool = false,
	NumLock: bool = false,
	CapsLock: bool = false,
	Mode: bool = false,
	ScrollLock: bool = false,
	pub const none = KeyModifier{
		.LeftShift = false,
	};

	/// Convert from an SDL value.
	pub fn fromSdl(flags: C.SDL_Keymod) KeyModifier {
		return .{
			.LeftShift = (flags & C.SDL_KMOD_LSHIFT) != 0,
			.RightShift = (flags & C.SDL_KMOD_RSHIFT) != 0,
			.LeftControl = (flags & C.SDL_KMOD_LCTRL) != 0,
			.RightControl = (flags & C.SDL_KMOD_RCTRL) != 0,
			.LeftAlt = (flags & C.SDL_KMOD_LALT) != 0,
			.RightAlt = (flags & C.SDL_KMOD_RALT) != 0,
			.LeftGui = (flags & C.SDL_KMOD_LGUI) != 0,
			.RightGui = (flags & C.SDL_KMOD_RGUI) != 0,
			.NumLock = (flags & C.SDL_KMOD_NUM) != 0,
			.CapsLock = (flags & C.SDL_KMOD_CAPS) != 0,
			.Mode = (flags & C.SDL_KMOD_MODE) != 0,
			.ScrollLock = (flags & C.SDL_KMOD_SCROLL) != 0,
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: KeyModifier) C.SDL_Keymod {
		return (if (self.LeftShift) @as(C.SDL_Keymod, C.SDL_KMOD_LSHIFT) else 0) |
			(if (self.RightShift) @as(C.SDL_Keymod, C.SDL_KMOD_RSHIFT) else 0) |
			(if (self.LeftControl) @as(C.SDL_Keymod, C.SDL_KMOD_LCTRL) else 0) |
			(if (self.RightControl) @as(C.SDL_Keymod, C.SDL_KMOD_RCTRL) else 0) |
			(if (self.LeftAlt) @as(C.SDL_Keymod, C.SDL_KMOD_LALT) else 0) |
			(if (self.RightAlt) @as(C.SDL_Keymod, C.SDL_KMOD_RALT) else 0) |
			(if (self.LeftGui) @as(C.SDL_Keymod, C.SDL_KMOD_LGUI) else 0) |
			(if (self.RightGui) @as(C.SDL_Keymod, C.SDL_KMOD_RGUI) else 0) |
			(if (self.NumLock) @as(C.SDL_Keymod, C.SDL_KMOD_NUM) else 0) |
			(if (self.CapsLock) @as(C.SDL_Keymod, C.SDL_KMOD_CAPS) else 0) |
			(if (self.Mode) @as(C.SDL_Keymod, C.SDL_KMOD_MODE) else 0) |
			(if (self.ScrollLock) @as(C.SDL_Keymod, C.SDL_KMOD_SCROLL) else 0) |
			0;
	}

	/// If any control key is down.
    pub fn controlDown(self: KeyModifier) bool {
        return self.value & C.SDL_KMOD_CTRL != 0;
    }

	/// If any shift key is down.
    pub fn shiftDown(self: KeyModifier) bool {
        return self.value & C.SDL_KMOD_SHIFT != 0;
    }

	/// If any alt key is down.
    pub fn altDown(self: KeyModifier) bool {
        return self.value & C.SDL_KMOD_ALT != 0;
    }

	/// If any gui key is down.
    pub fn guiDown(self: KeyModifier) bool {
        return self.value & C.SDL_KMOD_GUI != 0;
    }
};

const scancode = @import("scancode.zig");
