const std = @import("std");
const sdl3 = @import("sdl3");

pub fn main() !void {
    sdl3.Error.signalOutOfMemory();
    try std.io.getStdOut().writer().print("Err: {s}\n", .{sdl3.Error.get().?});
}
