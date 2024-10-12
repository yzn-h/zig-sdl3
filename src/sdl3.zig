pub const blend_mode = @import("blend_mode.zig");
pub const clipboard = @import("clipboard.zig");
pub const errors = @import("errors.zig");
pub const GUID = @import("guid.zig").GUID;
pub const hints = @import("hints.zig");
pub const init = @import("init.zig");
pub const SharedObject = @import("loadso.zig").SharedObject;
pub const Locale = @import("locale.zig").Locale;
pub const message_box = @import("message_box.zig");
pub const openURL = @import("misc.zig").openURL;
pub const pen = @import("pen.zig");
pub const PowerState = @import("power.zig").PowerState;
pub const properties = @import("properties.zig");
pub const time = @import("time.zig");
pub const Version = @import("version.zig").Version;

pub const C = @import("c.zig").C;

const std = @import("std");

/// Free memory allocated with SDL. For slices, pass in the pointer.
pub fn free(mem: ?*anyopaque) void {
    C.SDL_free(mem);
}

test {
    std.testing.refAllDecls(@This());
}
