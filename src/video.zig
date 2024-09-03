const C_SDL = @import("c_sdl.zig").C_SDL;
const Error = @import("error.zig").Error;
const Group = @import("properties.zig").Group;
const pixels = @import("pixels.zig");
const rect = @import("rect.zig");
const std = @import("std");
const Surface = @import("surface.zig").Surface;

/// Unique ID for a display.
const DisplayID = C_SDL.SDL_DisplayID;

/// Display orientation.
pub const DisplayOrientation = enum(c_int) {
    Unknown = C_SDL.SDL_ORIENTATION_UNKNOWN,
    Landscape = C_SDL.SDL_ORIENTATION_LANDSCAPE,
    LandscapeFlipped = C_SDL.SDL_ORIENTATION_LANDSCAPE_FLIPPED,
    Portrait = C_SDL.SDL_ORIENTATION_PORTRAIT,
    PortraitFlipped = C_SDL.SDL_ORIENTATION_PORTRAIT_FLIPPED,
};

/// Display mode handle.
const DisplayModeHandle = C_SDL.SDL_DisplayModeData;

/// Mode for displaying.
pub const DisplayMode = struct {
    const Self = @This();
    handle: ?*DisplayModeHandle,
    display: Display,
    pixel_format: pixels.Format,
    width: usize,
    height: usize,
    pixel_density: f32,
    refresh_rate: ?f32,
    refresh_rate_numerator: ?usize,
    refresh_rate_denominator: usize,

    /// Convert from SDL display mode.
    fn fromSdl(sdl: C_SDL.SDL_DisplayMode) Self {
        return .{
            .handle = sdl.internal,
            .display = Display.fromID(sdl.displayID),
            .pixel_format = @intFromEnum(sdl.format),
            .width = @intCast(sdl.w),
            .height = @intCast(sdl.h),
            .pixel_density = sdl.pixel_density,
            .refresh_rate = if (sdl.refresh_rate == 0.0) null else sdl.refresh_rate,
            .refresh_rate_numerator = if (sdl.refresh_rate_numerator == 0) null else @intCast(sdl.refresh_rate_numerator),
            .refresh_rate_denominator = @intCast(sdl.refresh_rate_denominator),
        };
    }

    /// Convert to SDL display mode.
    fn toSdl(self: Self) C_SDL.DisplayMode {
        return .{
            .format = @intFromEnum(self.pixel_format),
            .w = @intCast(self.width),
            .h = @intCast(self.height),
            .pixel_density = self.pixel_density,
            .refresh_rate = self.refresh_rate orelse 0.0,
            .refresh_rate_numerator = @as(c_int, self.refresh_rate_numerator) orelse 0,
            .refresh_rate_denominator = @intCast(self.refresh_rate_denominator),
            .internal = self.handle,
        };
    }
};

/// Actual display.
pub const Display = struct {
    const Self = @This();
    /// An invalid/null display.
    pub const invalid = Display{ .id = 0 };
    id: DisplayID,

    /// Get the display bounds. Primary display is always at (0, 0).
    pub fn bounds(self: Self) !rect.IRect {
        var ret: C_SDL.SDL_Rect = undefined;
        if (!C_SDL.SDL_GetDisplayBounds(self.id, &ret))
            return error.SDLError;
        return .{
            .x = @intCast(ret.x),
            .y = @intCast(ret.y),
            .w = @intCast(ret.w),
            .h = @intCast(ret.h),
        };
    }

    /// Find a display mode equal to or larger than the given mode. Refresh rate can be null for optional.
    pub fn closestFullscreenMode(self: Self, width: usize, height: usize, refresh_rate: ?f32, include_high_density_modes: bool) !DisplayMode {
        var ret: C_SDL.SDL_DisplayMode = undefined;
        if (!C_SDL.SDL_GetClosestFullscreenDisplayMode(self.id, @intCast(width), @intCast(height), refresh_rate orelse 0.0, include_high_density_modes, &ret))
            return error.SDLError;
        return DisplayMode.fromSdl(ret);
    }

    /// Get the scale for the screen. 200% (2.0) means user expects UI elements to be twice as big.ss
    pub fn contentScale(self: Self) !f32 {
        const ret = C_SDL.SDL_GetDisplayContentScale(self.id);
        if (ret == 0.0)
            return error.SDLError;
        return ret;
    }

    /// Get the current display mode.
    pub fn currentMode(self: Self) !DisplayMode {
        const ret = C_SDL.SDL_GetCurrentDisplayMode(self.id);
        if (ret == 0)
            return error.SDLError;
        return DisplayMode.fromSdl(ret);
    }

    /// Get the current orientation of the screen.
    pub fn currentOrientation(self: Self) DisplayOrientation {
        return @enumFromInt(C_SDL.SDL_GetCurrentDisplayOrientation(self.id));
    }

    /// Get the desktop display mode. Will return previous native display mode if fullscreen and resolution was changed.
    pub fn desktopMode(self: Self) !DisplayMode {
        const ret = C_SDL.SDL_GetDesktopDisplayMode(self.id);
        if (ret == 0)
            return error.SDLError;
        return DisplayMode.fromSdl(ret);
    }

    /// Get the display containing a point.
    pub fn forPoint(point: rect.IPoint) !Display {
        const p = C_SDL.SDL_Point{ .x = @intCast(point.x), .y = @intCast(point.y) };
        const ret = C_SDL.SDL_GetDisplayForPoint(&p);
        if (ret == Display.invalid.id)
            return error.SDLError;
        return Display.fromID(ret);
    }

    /// Get the display containing a rect (closest to center of rect).
    pub fn forRect(rectangle: rect.IRect) !Display {
        const r = C_SDL.SDL_Rect{ .x = @intCast(rectangle.x), .y = @intCast(rectangle.y), .w = @intCast(rectangle.w), .h = @intCast(rectangle.h) };
        const ret = C_SDL.SDL_GetDisplayForRect(&r);
        if (ret == Display.invalid.id)
            return error.SDLError;
        return Display.fromID(ret);
    }

    /// Create a display from an SDL ID.
    fn fromID(id: DisplayID) Display {
        return .{ .id = id };
    }

    // TODO: Fullscreen display modes!!!

    /// Get the currently connected displays. Memory returned must be freed.
    pub fn get(allocator: std.mem.Allocator) ![]Display {
        var count: c_int = undefined;
        const list = C_SDL.SDL_GetDisplays(&count);
        if (list == 0)
            return error.SDLError;
        var displays = try allocator.alloc(Display, @intCast(count));
        for (0..@intCast(count)) |ind| {
            displays[ind] = fromID(list[ind]);
        }
        C_SDL.SDL_free(list);
        return displays;
    }

    /// If display properties has HDR.
    pub fn hasHDR(self: Self) !?bool {
        const group = try self.properties();
        return group.getBool(C_SDL.SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN);
    }

    /// Get the name of the display.
    pub fn name(self: Self) ![]const u8 {
        const val = C_SDL.SDL_GetDisplayName(self.id);
        if (val != 0) {
            return std.mem.span(val);
        }
        return error.SDLError;
    }

    /// Get the natural orientation of the screen when not rotated.
    pub fn naturalOrientation(self: Self) DisplayOrientation {
        return @enumFromInt(C_SDL.SDL_GetNaturalDisplayOrientation(self.id));
    }

    /// If display properties has panel orientation in degrees.
    pub fn panelOrientationDegrees(self: Self) !?i64 {
        const group = try self.properties();
        return group.getNumber(C_SDL.SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER);
    }

    /// Get the primary display.
    pub fn primary() !Display {
        const id = C_SDL.SDL_GetPrimaryDisplay();
        if (id == 0)
            return error.SDLError;
        return fromID(id);
    }

    /// Get the display properties.
    pub fn properties(self: Self) !Group {
        const val = C_SDL.SDL_GetDisplayProperties(self.id);
        if (val == Group.invalid.id)
            return error.SDLError;
        return .{ .id = self.id };
    }

    /// Get the usable display bounds in screen coordinates.
    pub fn usableBounds(self: Self) !rect.IRect {
        var ret: C_SDL.SDL_Rect = undefined;
        if (!C_SDL.SDL_GetDisplayUsableBounds(self.id, &ret))
            return error.SDLError;
        return .{
            .x = @intCast(ret.x),
            .y = @intCast(ret.y),
            .w = @intCast(ret.w),
            .h = @intCast(ret.h),
        };
    }
};

/// Unique ID for a window.
const WindowID = C_SDL.SDL_WindowID;

/// Theme of the system in use.
pub const SystemTheme = enum(c_int) {
    Unknown = C_SDL.SDL_SYSTEM_THEME_UNKNOWN,
    Light = C_SDL.SDL_SYSTEM_THEME_LIGHT,
    Dark = C_SDL.SDL_SYSTEM_THEME_DARK,
};

/// Window flags.
pub const WindowFlags = struct {
    const Self = @This();
    fullscreen: bool = false,
    opengl: bool = false,
    occluded: bool = false,
    hidden: bool = false,
    borderless: bool = false,
    resizable: bool = false,
    minimized: bool = false,
    maximized: bool = false,
    mouse_grabbed: bool = false,
    input_focus: bool = false,
    mouse_focus: bool = false,
    external: bool = false,
    modal: bool = false,
    high_pixel_density: bool = false,
    mouse_capture: bool = false,
    mouse_relative_mode: bool = false,
    always_on_top: bool = false,
    utility: bool = false,
    tooltip: bool = false,
    popup_menu: bool = false,
    keyboard_grabbed: bool = false,
    vulkan: bool = false,
    metal: bool = false,
    transparent: bool = false,
    not_focusable: bool = false,

    /// Convert to 64-bit integer.
    fn asU64(self: Self) u64 {
        return (if (self.fullscreen) C_SDL.SDL_WINDOW_FULLSCREEN else 0) |
            (if (self.opengl) C_SDL.SDL_WINDOW_OPENGL else 0) |
            (if (self.occluded) C_SDL.SDL_WINDOW_OCCLUDED else 0) |
            (if (self.hidden) C_SDL.SDL_WINDOW_HIDDEN else 0) |
            (if (self.borderless) C_SDL.SDL_WINDOW_BORDERLESS else 0) |
            (if (self.resizable) C_SDL.SDL_WINDOW_RESIZABLE else 0) |
            (if (self.minimized) C_SDL.SDL_WINDOW_MINIMIZED else 0) |
            (if (self.maximized) C_SDL.SDL_WINDOW_MAXIMIZED else 0) |
            (if (self.mouse_grabbed) C_SDL.SDL_WINDOW_MOUSE_GRABBED else 0) |
            (if (self.input_focus) C_SDL.SDL_WINDOW_INPUT_FOCUS else 0) |
            (if (self.mouse_focus) C_SDL.SDL_WINDOW_MOUSE_FOCUS else 0) |
            (if (self.external) C_SDL.SDL_WINDOW_EXTERNAL else 0) |
            (if (self.modal) C_SDL.SDL_WINDOW_MODAL else 0) |
            (if (self.high_pixel_density) C_SDL.SDL_WINDOW_HIGH_PIXEL_DENSITY else 0) |
            (if (self.mouse_capture) C_SDL.SDL_WINDOW_MOUSE_CAPTURE else 0) |
            (if (self.mouse_relative_mode) C_SDL.SDL_WINDOW_MOUSE_RELATIVE_MODE else 0) |
            (if (self.always_on_top) C_SDL.SDL_WINDOW_ALWAYS_ON_TOP else 0) |
            (if (self.utility) C_SDL.SDL_WINDOW_UTILITY else 0) |
            (if (self.tooltip) C_SDL.SDL_WINDOW_TOOLTIP else 0) |
            (if (self.popup_menu) C_SDL.SDL_WINDOW_POPUP_MENU else 0) |
            (if (self.keyboard_grabbed) C_SDL.SDL_WINDOW_KEYBOARD_GRABBED else 0) |
            (if (self.vulkan) C_SDL.SDL_WINDOW_VULKAN else 0) |
            (if (self.metal) C_SDL.SDL_WINDOW_METAL else 0) |
            (if (self.transparent) C_SDL.SDL_WINDOW_TRANSPARENT else 0) |
            (if (self.not_focusable) C_SDL.SDL_WINDOW_NOT_FOCUSABLE else 0);
    }

    /// Get flags from 64-bit integer.
    fn fromU64(flags: u64) Self {
        return .{
            .fullscreen = (flags & C_SDL.SDL_WINDOW_FULLSCREEN) != 0,
            .opengl = (flags & C_SDL.SDL_WINDOW_OPENGL) != 0,
            .occluded = (flags & C_SDL.SDL_WINDOW_OCCLUDED) != 0,
            .hidden = (flags & C_SDL.SDL_WINDOW_HIDDEN) != 0,
            .borderless = (flags & C_SDL.SDL_WINDOW_BORDERLESS) != 0,
            .resizable = (flags & C_SDL.SDL_WINDOW_RESIZABLE) != 0,
            .minimized = (flags & C_SDL.SDL_WINDOW_MINIMIZED) != 0,
            .maximized = (flags & C_SDL.SDL_WINDOW_MAXIMIZED) != 0,
            .mouse_grabbed = (flags & C_SDL.SDL_WINDOW_MOUSE_GRABBED) != 0,
            .input_focus = (flags & C_SDL.SDL_WINDOW_INPUT_FOCUS) != 0,
            .mouse_focus = (flags & C_SDL.SDL_WINDOW_MOUSE_FOCUS) != 0,
            .external = (flags & C_SDL.SDL_WINDOW_EXTERNAL) != 0,
            .modal = (flags & C_SDL.SDL_WINDOW_MODAL) != 0,
            .high_pixel_density = (flags & C_SDL.SDL_WINDOW_HIGH_PIXEL_DENSITY) != 0,
            .mouse_capture = (flags & C_SDL.SDL_WINDOW_MOUSE_CAPTURE) != 0,
            .mouse_relative_mode = (flags & C_SDL.SDL_WINDOW_MOUSE_RELATIVE_MODE) != 0,
            .always_on_top = (flags & C_SDL.SDL_WINDOW_ALWAYS_ON_TOP) != 0,
            .utility = (flags & C_SDL.SDL_WINDOW_UTILITY) != 0,
            .tooltip = (flags & C_SDL.SDL_WINDOW_TOOLTIP) != 0,
            .popup_menu = (flags & C_SDL.SDL_WINDOW_POPUP_MENU) != 0,
            .keyboard_grabbed = (flags & C_SDL.SDL_WINDOW_KEYBOARD_GRABBED) != 0,
            .vulkan = (flags & C_SDL.SDL_WINDOW_VULKAN) != 0,
            .metal = (flags & C_SDL.SDL_WINDOW_METAL) != 0,
            .transparent = (flags & C_SDL.SDL_WINDOW_TRANSPARENT) != 0,
            .not_focusable = (flags & C_SDL.SDL_WINDOW_NOT_FOCUSABLE) != 0,
        };
    }
};

/// Opaque handle for a window.
pub const WindowHandle = C_SDL.SDL_Window;

/// Window.
pub const Window = struct {
    const Self = @This();
    const invalid = Self{ .handle = 0 };
    handle: *WindowHandle,

    /// Window properties.
    pub const Properties = struct {
        const PSelf = @This();
        group: Group,

        /// Initialize the window properties.
        pub fn init() !PSelf {
            return .{
                .group = try Group.init(),
            };
        }

        /// Deinitialize the properties.
        pub fn deinit(self: PSelf) void {
            self.group.deinit();
        }

        /// If the window is always on top.
        pub fn getAlwaysOnTop(self: PSelf) ?bool {
            return self.group.getBool(C_SDL.SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN);
        }

        /// If the window is borderless.
        pub fn getBorderless(self: PSelf) ?bool {
            return self.group.getBool(C_SDL.SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN);
        }

        /// If the window is focusable.
        pub fn getFocusable(self: PSelf) ?bool {
            return self.group.getBool(C_SDL.SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN);
        }

        /// Set if the window is always on top.
        pub fn setAlwaysOnTop(self: PSelf, value: ?bool) !void {
            try self.group.setBoolean(C_SDL.SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN, value);
        }

        /// Set if the window is borderless.
        pub fn setBorderless(self: PSelf, value: ?bool) !void {
            try self.group.setBoolean(C_SDL.SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN, value);
        }

        /// Set if the window is focusable.
        pub fn setFocusable(self: PSelf, value: ?bool) !void {
            try self.group.setBoolean(C_SDL.SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN, value);
        }

        // TODO: More properties!!! Take into account platform too!
    };

    /// Destroy the window.
    pub fn deinit(self: Self) void {
        C_SDL.SDL_DestroyWindow(self.handle);
    }

    /// Get the display containing the center of the window.
    pub fn display(self: Self) !Display {
        const ret = C_SDL.SDL_GetDisplayForWindow(self.handle);
        if (ret == Window.invalid.handle)
            return error.SDLError;
        return fromHandle(ret);
    }

    /// The scale of which content should be drawn on the screen.
    pub fn displayScale(self: Self) !f32 {
        const ret = C_SDL.SDL_GetWindowDisplayScale(self.handle);
        if (ret == 0.0)
            return error.SDLError;
        return ret;
    }

    /// Get window flags.
    pub fn flags(self: Self) WindowFlags {
        return WindowFlags.fromU64(C_SDL.SDL_GetWindowFlags(self.handle));
    }

    /// Get a window from an SDL handle.
    fn fromHandle(handle: *WindowHandle) Self {
        return .{ .handle = handle };
    }

    /// Get a window from an ID.
    pub fn fromID(window_id: WindowID) !Self {
        const ret = C_SDL.SDL_GetWindowFromID(window_id);
        if (ret == 0)
            return error.SDLError;
        return fromHandle(ret);
    }

    /// Window aspect ratio. Null value means no limit.
    pub const AspectRatio = struct {
        min: ?f32,
        max: ?f32,
    };

    /// Get the aspect ratio of the window.
    pub fn getAspectRatio(self: Self) !AspectRatio {
        var min: f32 = undefined;
        var max: f32 = undefined;
        if (!C_SDL.SDL_GetWindowAspectRatio(self.handle, &min, &max))
            return error.SDLError;
        return .{ .min = if (min == 0.0) null else min, .max = if (max == 0.0) null else max };
    }

    /// Get the window fullscreen mode. Null is borderless fullscreen.
    pub fn getFullscreenMode(self: Self) ?DisplayMode {
        const ret = C_SDL.SDL_GetWindowFullscreenMode(self.handle);
        if (ret == 0)
            return null;
        return DisplayMode.fromSdl(ret);
    }

    /// Get the position of the window.
    pub fn getPosition(self: Self) !rect.IPoint {
        var x: c_int = undefined;
        var y: c_int = undefined;
        if (!C_SDL.SDL_GetWindowPosition(self.handle, &x, &y))
            return error.SDLError;
        return .{ .x = @intCast(x), .y = @intCast(y) };
    }

    /// Get the area that's safe to put interactable components.
    pub fn getSafeArea(self: Self) !rect.IRect {
        var ret: C_SDL.SDL_Rect = undefined;
        if (!C_SDL.SDL_GetWindowSafeArea(self.handle, &ret))
            return error.SDLError;
        return .{ .x = @intCast(ret.x), .y = @intCast(ret.y), .w = @intCast(ret.w), .h = @intCast(ret.h) };
    }

    /// Get the size of the window.
    pub fn getSize(self: Self) !rect.IPoint {
        var w: c_int = undefined;
        var h: c_int = undefined;
        if (!C_SDL.SDL_GetWindowSize(self.handle, &w, &h))
            return error.SDLError;
        return .{ .x = @intCast(w), .y = @intCast(h) };
    }

    /// Get the title of the window.
    pub fn getTitle(self: Self) ?[]const u8 {
        const ret = C_SDL.SDL_GetWindowTitle(self.handle);
        if (std.mem.eql(u8, ret, ""))
            return null;
        return std.mem.span(ret);
    }

    /// Get the window's ICC profile data. Note that it should be freed when not needed anymore.
    pub fn iccProfile(self: Self, allocator: std.mem.Allocator) ![]u8 {
        var size: usize = undefined;
        const tmp: ?*u8 = if (C_SDL.SDL_GetWindowICCProfile(self.handle, &size)) |val| @ptrCast(val) else null;
        if (tmp) |val| {
            var ret = try allocator.alloc(u8, size);
            @memcpy(ret, val);
            C_SDL.SDL_free(tmp);
            return ret;
        }
        return error.SDLError;
    }

    /// Get the ID of the window.
    pub fn id(self: Self) !WindowID {
        const ret = C_SDL.SDL_GetWindowID(self.handle);
        if (ret == 0)
            return error.SDLError;
        return ret;
    }

    /// Initialize a window.
    pub fn init(title: [:0]const u8, width: usize, height: usize, window_flags: WindowFlags) !Window {
        const ret = C_SDL.SDL_CreateWindow(title, @intCast(width), @intCast(height), window_flags.asU64());
        if (ret) |val|
            return fromHandle(val);
        return error.SDLError;
    }

    /// Initialize a window from properties.
    pub fn initFromProperties(properties: Properties) !Window {
        const ret = C_SDL.SDL_CreateWindowWithProperties(properties.group.id);
        if (ret) |val|
            return fromHandle(val);
        return error.SDLError;
    }

    /// Get the parent of the window if it exists.
    pub fn parent(self: Self) ?Self {
        const ret = C_SDL.SDL_GetWindowParent(self.handle);
        if (ret) |val| {
            return fromHandle(val);
        }
        return null;
    }

    /// Get the pixel density or how much the size is scaled to the backbuffer size.
    pub fn pixelDensity(self: Self) !f32 {
        const ret = C_SDL.SDL_GetWindowPixelDensity(self.handle);
        if (ret == 0.0)
            return error.SDLError;
        return ret;
    }

    /// Get the pixel format of the window.
    pub fn pixelFormat(self: Self) !pixels.Format {
        const ret = C_SDL.SDL_GetWindowPixelFormat(self.handle);
        if (ret == C_SDL.SDL_PIXELFORMAT_UNKNOWN)
            return error.SDLError;
        return @enumFromInt(ret);
    }

    /// Create a child popup window. Note that the flags have to have one of tooltip or popup set. Minimized, maximized, fullscreen, and borderless flags are ignored. If the parent is deinit'd, this is too.
    pub fn popup(self: Self, offset_x: i32, offset_y: i32, width: usize, height: usize, window_flags: WindowFlags) !Window {
        const ret = C_SDL.SDL_CreatePopupWindow(
            self.handle,
            @intCast(offset_x),
            @intCast(offset_y),
            @intCast(width),
            @intCast(height),
            window_flags.asU64(),
        );
        if (ret) |val|
            return fromHandle(val);
        return error.SDLError;
    }

    // TODO: Get properties! Make sure to take into account platforms.

    /// Set the aspect ratio of the window.
    pub fn setAspectRatio(self: Self, ratio: AspectRatio) !void {
        const min = ratio.min orelse 0.0;
        const max = ratio.max orelse 0.0;
        if (!C_SDL.SDL_SetWindowAspectRatio(self.handle, min, max))
            return error.SDLError;
    }

    /// Set the display mode for when the window is fullscreen. A null mode will be borderless fullscreen.
    pub fn setFullscreenMode(self: Self, mode: ?DisplayMode) !void {
        var m: C_SDL.SDL_DisplayMode = undefined;
        if (mode) |val| {
            m = val.toSdl();
        }
        if (!C_SDL.SDL_SetWindowFullscreenMode(self.handle, if (mode) &m else 0))
            return error.SDLError;
    }

    /// Set the window icon.
    pub fn setIcon(self: Self, icon: Surface) !void {
        if (!C_SDL.SDL_SetWindowIcon(self.handle, icon.handle))
            return error.SDLError;
    }

    /// Position type.
    pub const PositionType = enum {
        Normal,
        Undefined,
        Centered,
    };

    /// Position coordinate.
    pub const Position = union(PositionType) {
        Normal: i32,
        Undefined: void,
        Centered: void,
    };

    /// Set the position of the window.
    pub fn setPosition(self: Self, x: Position, y: Position) !void {
        const new_x: c_int = switch (x) {
            .Normal => |val| @intCast(val),
            .Undefined => C_SDL.SDL_WINDOWPOS_UNDEFINED,
            .Centered => C_SDL.SDL_WINDOWPOS_CENTERED,
        };
        const new_y: c_int = switch (y) {
            .Normal => |val| @intCast(val),
            .Undefined => C_SDL.SDL_WINDOWPOS_UNDEFINED,
            .Centered => C_SDL.SDL_WINDOWPOS_CENTERED,
        };
        if (!C_SDL.SDL_SetWindowPosition(self.handle, new_x, new_y))
            return error.SDLError;
    }

    /// Set the size of the window.
    pub fn setSize(self: Self, width: usize, height: usize) !void {
        if (!C_SDL.SDL_SetWindowSize(self.handle, @intCast(width), @intCast(height)))
            return error.SDLError;
    }

    /// Set the title to the window.
    pub fn setTitle(self: Self, title: [:0]const u8) !void {
        if (!C_SDL.SDL_SetWindowTitle(self.handle, title))
            return error.SDLError;
    }

    /// Get the window surface.
    pub fn surface(self: Self) !Surface {
        const ret = C_SDL.SDL_GetWindowSurface(self.handle);
        if (ret == 0)
            return error.SDLError;
        return .{ .handle = ret };
    }

    /// Upload the surface to the window.
    pub fn updateSurface(self: Self) !void {
        if (!C_SDL.SDL_UpdateWindowSurface(self.handle))
            return error.SDLError;
    }

    /// Get a list of valid windows. Returned slice must be freed.
    pub fn windows(allocator: std.mem.Allocator) ![]Self {
        var count: c_int = undefined;
        const tmp = C_SDL.SDL_GetWindows(&count);
        if (tmp) |val| {
            var ret = try allocator.alloc(Self, @intCast(count));
            for (0..count) |ind| {
                ret[ind] = Self.fromHandle(val[ind]);
            }
            return ret;
        }
        return error.SDLError;
    }
};

/// Get the number of video drivers compiled into SDL.
pub fn numDrivers() usize {
    return @intCast(C_SDL.SDL_GetNumVideoDrivers());
}

/// Get the video driver name at a given index. If the index is invalid, return null.
pub fn driverName(index: usize) ?[]const u8 {
    const val = C_SDL.SDL_GetVideoDriver(@intCast(index));
    if (val != 0) {
        return std.mem.span(val);
    }
    return null;
}

/// Get the name of the current video driver. Null if none have been initialized.
pub fn currentDriverName() ?[]const u8 {
    const val = C_SDL.SDL_GetCurrentVideoDriver();
    if (val != 0) {
        return std.mem.span(val);
    }
    return null;
}

/// Get the theme of the system.
pub fn systemTheme() SystemTheme {
    return @enumFromInt(C_SDL.SDL_GetSystemTheme());
}
