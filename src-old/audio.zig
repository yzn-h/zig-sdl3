// usingnamespace @import("c_sdl.zig");
const C_SDL = @cImport(@cInclude("SDL3/SDL.h"));
const Error = @import("error.zig");
const std = @import("std");

/// Audio format for SDL.
pub const Format = enum(c_int) {
    const Self = @This();
    Unknown = C_SDL.SDL_AUDIO_UNKNOWN,
    Unsigned8Bit = C_SDL.SDL_AUDIO_U8,
    Signed8Bit = C_SDL.SDL_AUDIO_S8,
    Signed16BitLittleEndian = C_SDL.SDL_AUDIO_S16LE,
    Signed16BitBigEndian = C_SDL.SDL_AUDIO_S16BE,
    Signed32BitLittleEndian = C_SDL.SDL_AUDIO_S32LE,
    Signed32BitBigEndian = C_SDL.SDL_AUDIO_S32BE,
    Float32BitLittleEndian = C_SDL.SDL_AUDIO_F32LE,
    Float32BitBigEndian = C_SDL.SDL_AUDIO_F32BE,

    /// Bits per sample of the format.
    pub fn bitSize(self: Self) u6 {
        return @intCast(C_SDL.SDL_AUDIO_BITSIZE(@intFromEnum(self)));
    }

    /// Bytes per sample of the format.
    pub fn byteSize(self: Self) u3 {
        return @intCast(C_SDL.SDL_AUDIO_BYTESIZE(@intFromEnum(self)));
    }

    /// If the audio format is big endian.
    pub fn isBigEndian(self: Self) bool {
        return C_SDL.SDL_AUDIO_ISBIGENDIAN(@intFromEnum(self)) > 0;
    }

    /// If the audio format is floating point.
    pub fn isFloat(self: Self) bool {
        return C_SDL.SDL_AUDIO_ISFLOAT(@intFromEnum(self)) > 0;
    }

    /// If the audio format is integer.
    pub fn isInt(self: Self) bool {
        return C_SDL.SDL_AUDIO_ISINT(@intFromEnum(self));
    }

    /// If the audio format is little endian.
    pub fn isLittleEndian(self: Self) bool {
        return C_SDL.SDL_AUDIO_ISLITTLEENDIAN(@intFromEnum(self));
    }

    ///If the audio format is signed.
    pub fn isSigned(self: Self) bool {
        return C_SDL.SDL_AUDIO_ISSIGNED(@intFromEnum(self)) > 0;
    }

    ///If the audio format is unsigned.
    pub fn isUnsigned(self: Self) bool {
        return C_SDL.SDL_AUDIO_ISUNSIGNED(@intFromEnum(self));
    }
};

test "Format" {

    // Bit size.
    try std.testing.expect(Format.Unsigned8Bit.bitSize() == 8);
    try std.testing.expect(Format.Signed8Bit.bitSize() == 8);
    try std.testing.expect(Format.Signed16BitLittleEndian.bitSize() == 16);
    try std.testing.expect(Format.Signed16BitBigEndian.bitSize() == 16);
    try std.testing.expect(Format.Signed32BitLittleEndian.bitSize() == 32);
    try std.testing.expect(Format.Signed32BitBigEndian.bitSize() == 32);
    try std.testing.expect(Format.Float32BitLittleEndian.bitSize() == 32);
    try std.testing.expect(Format.Float32BitBigEndian.bitSize() == 32);

    // Byte size.
    try std.testing.expect(Format.Unsigned8Bit.byteSize() == 1);
    try std.testing.expect(Format.Signed8Bit.byteSize() == 1);
    try std.testing.expect(Format.Signed16BitLittleEndian.byteSize() == 2);
    try std.testing.expect(Format.Signed16BitBigEndian.byteSize() == 2);
    try std.testing.expect(Format.Signed32BitLittleEndian.byteSize() == 4);
    try std.testing.expect(Format.Signed32BitBigEndian.byteSize() == 4);
    try std.testing.expect(Format.Float32BitLittleEndian.byteSize() == 4);
    try std.testing.expect(Format.Float32BitBigEndian.byteSize() == 4);

    // Is big endian.
    try std.testing.expect(!Format.Signed16BitLittleEndian.isBigEndian());
    try std.testing.expect(Format.Signed16BitBigEndian.isBigEndian());
    try std.testing.expect(!Format.Signed32BitLittleEndian.isBigEndian());
    try std.testing.expect(Format.Signed32BitBigEndian.isBigEndian());
    try std.testing.expect(!Format.Float32BitLittleEndian.isBigEndian());
    try std.testing.expect(Format.Float32BitBigEndian.isBigEndian());

    // Is float.
    try std.testing.expect(!Format.Unsigned8Bit.isFloat());
    try std.testing.expect(!Format.Signed8Bit.isFloat());
    try std.testing.expect(!Format.Signed16BitLittleEndian.isFloat());
    try std.testing.expect(!Format.Signed16BitBigEndian.isFloat());
    try std.testing.expect(!Format.Signed32BitLittleEndian.isFloat());
    try std.testing.expect(!Format.Signed32BitBigEndian.isFloat());
    try std.testing.expect(Format.Float32BitLittleEndian.isFloat());
    try std.testing.expect(Format.Float32BitBigEndian.isFloat());

    // Is int.
    try std.testing.expect(Format.Unsigned8Bit.isInt());
    try std.testing.expect(Format.Signed8Bit.isInt());
    try std.testing.expect(Format.Signed16BitLittleEndian.isInt());
    try std.testing.expect(Format.Signed16BitBigEndian.isInt());
    try std.testing.expect(Format.Signed32BitLittleEndian.isInt());
    try std.testing.expect(Format.Signed32BitBigEndian.isInt());
    try std.testing.expect(!Format.Float32BitLittleEndian.isInt());
    try std.testing.expect(!Format.Float32BitBigEndian.isInt());

    // Is little endian.
    try std.testing.expect(Format.Signed16BitLittleEndian.isLittleEndian());
    try std.testing.expect(!Format.Signed16BitBigEndian.isLittleEndian());
    try std.testing.expect(Format.Signed32BitLittleEndian.isLittleEndian());
    try std.testing.expect(!Format.Signed32BitBigEndian.isLittleEndian());
    try std.testing.expect(Format.Float32BitLittleEndian.isLittleEndian());
    try std.testing.expect(!Format.Float32BitBigEndian.isLittleEndian());

    // Is signed.
    try std.testing.expect(!Format.Unsigned8Bit.isSigned());
    try std.testing.expect(Format.Signed8Bit.isSigned());
    try std.testing.expect(Format.Signed16BitLittleEndian.isSigned());
    try std.testing.expect(Format.Signed16BitBigEndian.isSigned());
    try std.testing.expect(Format.Signed32BitLittleEndian.isSigned());
    try std.testing.expect(Format.Signed32BitBigEndian.isSigned());

    // Is unsigned.
    try std.testing.expect(Format.Unsigned8Bit.isUnsigned());
    try std.testing.expect(!Format.Signed8Bit.isUnsigned());
    try std.testing.expect(!Format.Signed16BitLittleEndian.isUnsigned());
    try std.testing.expect(!Format.Signed16BitBigEndian.isUnsigned());
    try std.testing.expect(!Format.Signed32BitLittleEndian.isUnsigned());
    try std.testing.expect(!Format.Signed32BitBigEndian.isUnsigned());
}

/// Device instance ID.
pub const DeviceID = struct {
    /// Default playback device ID.
    pub const default_playback = DeviceID{ .id = C_SDL.SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK };
    /// Default recording device ID.
    pub const default_recording = DeviceID{ .id = C_SDL.SDL_AUDIO_DEVICE_DEFAULT_RECORDING };
    /// Invalid/null ID.
    pub const invalid = DeviceID{ .id = 0 };
    id: u32,
};

test "DeviceID" {
    try std.testing.expect(!std.meta.eql(DeviceID.default_playback, DeviceID.default_recording));
    try std.testing.expect(!std.meta.eql(DeviceID.default_playback, DeviceID.invalid));
}

/// Audio format specifier.
pub const Spec = struct {
    const Self = @This();
    format: Format,
    channels: u16,
    freq: u24,

    /// How many bytes are in a sample frame (a single sample for each channel).
    pub fn bytesPerFrame(self: Self) usize {
        return self.format.byteSize() * self.channels;
    }
};

test "Spec" {
    try std.testing.expect((Spec{ .freq = 49000, .channels = 1, .format = Format.Unsigned8Bit }).bytesPerFrame() == 1);
    try std.testing.expect((Spec{ .freq = 49000, .channels = 2, .format = Format.Signed8Bit }).bytesPerFrame() == 2);
    try std.testing.expect((Spec{ .freq = 49000, .channels = 3, .format = Format.Signed16BitLittleEndian }).bytesPerFrame() == 6);
    try std.testing.expect((Spec{ .freq = 49000, .channels = 4, .format = Format.Signed16BitBigEndian }).bytesPerFrame() == 8);
    try std.testing.expect((Spec{ .freq = 49000, .channels = 5, .format = Format.Signed32BitLittleEndian }).bytesPerFrame() == 20);
    try std.testing.expect((Spec{ .freq = 49000, .channels = 6, .format = Format.Signed32BitBigEndian }).bytesPerFrame() == 24);
    try std.testing.expect((Spec{ .freq = 49000, .channels = 7, .format = Format.Float32BitLittleEndian }).bytesPerFrame() == 28);
    try std.testing.expect((Spec{ .freq = 49000, .channels = 8, .format = Format.Float32BitBigEndian }).bytesPerFrame() == 32);
}

/// Opaque stream format.
pub const Stream = C_SDL.SDL_AudioStream;

/// Number of audio drivers that SDL can interact with.
pub fn numDrivers() usize {
    return C_SDL.SDL_GetNumAudioDrivers();
}

/// Get the name of an audio driver, or null if invalid index.
pub fn driverName(index: usize) ?[*:0]const u8 {
    return C_SDL.SDL_GetAudioDriver(@intCast(index));
}

/// Get the name of the current audio driver in use. Is null if no driver has been initialized.
pub fn currentDriverName() ?[*:0]const u8 {
    return C_SDL.SDL_GetCurrentAudioDriver();
}

/// Get a list of devices used to play sound. Note that the caller needs to free the memory of the returned slice.
pub fn playbackDevices(allocator: std.mem.Allocator) ![]const DeviceID {
    var count: c_int = undefined;
    const arr = C_SDL.SDL_GetAudioPlaybackDevices(&count);
    if (arr == null or count < 1)
        return error.SDLError;
    var ret: []DeviceID = &[_]DeviceID{};
    ret.len = @intCast(count);
    const new_mem = try allocator.alloc(DeviceID, ret.len);
    ret.ptr = new_mem.ptr;
    for (std.mem.span(arr), 0..) |item, ind| {
        ret.ptr[ind].id = item;
    }
    return ret;
}

// TODO: TEST PLAYBACK DEVICES AND MAKE IDENTICAL RECORDING DEVICES FUNCTION!

/// Get the human readable name of an audio device.
pub fn deviceName(device: DeviceID) ![]const u8 {
    const res = C_SDL.SDL_GetAudioDeviceName(device.id);
    if (res == null)
        return error.SDLError;
    return std.mem.span(res);
}

/// The format of an audio device.
pub const DeviceFormat = struct {
    /// Audio specification format.
    spec: Spec,
    /// Device buffer size in sample frames.
    sample_frames: usize,
};

/// Get the audio format of a device.
pub fn deviceFormat(device: DeviceID) !DeviceFormat {
    var sample_frames: c_int = undefined;
    var audio_spec: C_SDL.SDL_AudioSpec = undefined;
    if (!C_SDL.SDL_GetAudioDeviceFormat(device.id, &audio_spec, &sample_frames))
        return error.SDLError;
    return DeviceFormat{
        .spec = .{
            .format = audio_spec.format,
            .channels = @intCast(audio_spec.channels),
            .freq = @intCast(audio_spec.freq),
        },
        .sample_frames = @intCast(sample_frames),
    };
}

// TODO: EVERYTHING ELSE!!!
