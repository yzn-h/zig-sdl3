const C_SDL = @import("c_sdl.zig").C_SDL;
const Error = @import("error.zig").Error;
const std = @import("std");

fn streamSize(data: ?*anyopaque) callconv(.C) i64 {
    var stream: *std.io.StreamSource = @ptrCast(@alignCast(data.?));
    const end_pos = stream.getEndPos() catch return -1;
    return @intCast(end_pos);
}

fn streamSeek(data: ?*anyopaque, offset: i64, whence: c_uint) callconv(.C) i64 {
    var stream: *std.io.StreamSource = @ptrCast(@alignCast(data.?));
    switch (whence) {
        C_SDL.SDL_IO_SEEK_CUR => stream.seekBy(offset) catch return -1,
        C_SDL.SDL_IO_SEEK_SET => stream.seekTo(@intCast(offset)) catch return -1,
        C_SDL.SDL_IO_SEEK_END => {
            const end_pos = stream.getEndPos() catch return -1;
            if (offset > end_pos)
                return -1;
            stream.seekTo(@intCast(end_pos - @as(u64, @intCast(offset)))) catch return -1;
        },
        else => return -1,
    }
    const pos = stream.getPos() catch return -1;
    return @as(i64, @intCast(pos));
}

fn streamRead(data: ?*anyopaque, ptr: ?*anyopaque, size: usize, status: [*c]c_uint) callconv(.C) usize {
    var stream: *std.io.StreamSource = @ptrCast(@alignCast(data.?));
    var dest: [*]u8 = @ptrCast(ptr.?);
    return stream.read(dest[0..size]) catch blk: {
        status.* = C_SDL.SDL_IO_STATUS_ERROR;
        break :blk 0;
    };
}

fn streamWrite(data: ?*anyopaque, ptr: ?*const anyopaque, size: usize, status: [*c]c_uint) callconv(.C) usize {
    var stream: *std.io.StreamSource = @ptrCast(@alignCast(data.?));
    var src: [*]const u8 = @ptrCast(ptr.?);
    return stream.write(src[0..size]) catch blk: {
        status.* = C_SDL.SDL_IO_STATUS_ERROR;
        break :blk 0;
    };
}

fn streamClose(data: ?*anyopaque) callconv(.C) bool {
    _ = data;
    return true;
}

/// Handle for streams.
pub const StreamHandle = *C_SDL.SDL_IOStream;

/// Stream for working with SDL IO streams. This just wraps around a stream source so SDL can use it. You should read and write from the stream source.
pub const Stream = struct {
    const Self = @This();
    const interface = C_SDL.SDL_IOStreamInterface{
        .size = streamSize,
        .seek = streamSeek,
        .read = streamRead,
        .write = streamWrite,
        .close = streamClose,
    };
    handle: StreamHandle,

    /// Initialize a stream for compatibility with SDL. Note the source must exist for the lifetime of this stream. Read and write to the stream using the source you provide.
    pub fn init(source: *std.io.StreamSource) !Self {
        const ret = C_SDL.SDL_OpenIO(&interface, source);
        if (ret) |val| {
            return .{ .handle = val };
        }
        return error.SDLError;
    }

    /// Cleanup the stream.
    pub fn deinit(self: Self) !void {
        if (!C_SDL.SDL_CloseIO(self.handle))
            return error.SDLError;
    }
};

test "Stream" {
    var buffer: [64]u8 = undefined;
    var source = std.io.StreamSource{ .buffer = std.io.fixedBufferStream(&buffer) };
    const stream = try Stream.init(&source);
    defer stream.deinit() catch {};
    try std.testing.expect(C_SDL.SDL_WriteU8(stream.handle, 7));
    try std.testing.expect(buffer[0] == 7);
    buffer[1] = 3;
    var val: u8 = undefined;
    try std.testing.expect(C_SDL.SDL_ReadU8(stream.handle, &val));
    try std.testing.expect(val == 3);
    try std.testing.expect(C_SDL.SDL_GetIOSize(stream.handle) == 64);
    try std.testing.expect(C_SDL.SDL_SeekIO(stream.handle, 50, C_SDL.SDL_IO_SEEK_SET) == 50);
    try std.testing.expect(C_SDL.SDL_SeekIO(stream.handle, 23, C_SDL.SDL_IO_SEEK_END) == 41);
    try std.testing.expect(C_SDL.SDL_SeekIO(stream.handle, 2, C_SDL.SDL_IO_SEEK_CUR) == 43);
}
