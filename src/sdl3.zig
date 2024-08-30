pub const Audio = @import("audio.zig");
pub const C = @import("c_sdl.zig").C_SDL;
pub const Error = @import("error.zig");
pub const Init = @import("init.zig");
pub const MessageBox = @import("message_box.zig");
const std = @import("std");

test {
    std.testing.refAllDecls(@This());
}
