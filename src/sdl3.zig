pub const blend = @import("blend.zig");
pub const clipboard = @import("clipboard.zig");
pub const errors = @import("errors.zig");
pub const init = @import("init.zig");
pub const loadso = @import("loadso.zig");
pub const message_box = @import("message_box.zig");
pub const misc = @import("misc.zig");
pub const properties = @import("properties.zig");

pub const C = @import("c.zig").C;

const std = @import("std");

/// Free memory allocated with SDL. For slices, pass in the pointer.
pub fn free(mem: ?*anyopaque) void {
    C.SDL_free(mem);
}

test {
    std.testing.refAllDecls(@This());
}
