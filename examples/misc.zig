const sdl3 = @import("sdl3");

pub fn main() !void {
    try sdl3.misc.openURL("https://github.com/Gota7/zig-sdl3");
}
