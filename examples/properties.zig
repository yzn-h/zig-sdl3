const sdl3 = @import("sdl3");
const std = @import("std");

fn printPropertyType(typ: sdl3.properties.Type) []const u8 {
    return switch (typ) {
        .Invalid => "[does not exist]",
        .Pointer => "pointer",
        .String => "string",
        .Number => "number",
        .Float => "float",
        .Boolean => "boolean",
    };
}

fn arrayCleanupCallback(user_data: *void, data: *std.ArrayList(u32)) callconv(.C) void {
    data.deinit();
    _ = user_data;
}

fn printItems(user_data: *usize, group: sdl3.properties.Group, name: []const u8) void {
    std.io.getStdOut().writer().print("Index: {d}, Name: \"{s}\", Type: {s}\n", .{
        user_data.*,
        name,
        printPropertyType(group.getType(@ptrCast(name))),
    }) catch std.io.getStdErr().writer().print("Standard writer error\n", .{}) catch {};
    user_data.* += 1;
}

pub fn main() !void {
    const properties = try sdl3.properties.Group.init();
    defer properties.deinit();
    var num: u32 = 3;
    try properties.setBoolean("myBool", true);
    try properties.setNumber("myNum", 7);
    try properties.setPointer("myNumPtr", &num);
    try properties.setString("myStr", "Hello World!");

    const allocator = std.heap.c_allocator;
    var arr = std.ArrayList(u32).init(allocator);
    var null_data: void = {};
    try properties.setPointerWithCleanup("myArr", void, &null_data, @TypeOf(arr), &arr, arrayCleanupCallback);

    const writer = std.io.getStdOut().writer();
    try writer.print("Type of \"myStr\" is {s}\n", .{printPropertyType(properties.getType("myStr"))});
    try writer.print("Type of \"isNotThere\" is {s}\n\n", .{printPropertyType(properties.getType("isNotThere"))});

    var index: usize = 0;
    try properties.enumerate(@TypeOf(index), &index, printItems);

    try writer.print("\nNotice that since \"myArr\" has a custom deleter that it is not present!\n", .{});
    const global_properties = try sdl3.properties.Group.global();
    try properties.copyTo(global_properties);
    var set = try global_properties.getAll(allocator);
    defer set.deinit();
    var iterator = set.iterator();
    index = 0;
    while (iterator.next()) |item| {
        try writer.print("Index: {d}, Name: \"{s}\", Type: {s}\n", .{ index, item.key_ptr.*, printPropertyType(global_properties.getType(@ptrCast(item.key_ptr.*))) });
        index += 1;
    }

    try writer.print("\nYou can remove or set an item as null\n", .{});
    index = 0;
    try properties.remove("myNumPtr");
    try properties.setString("myStr", null);
    try properties.enumerate(@TypeOf(index), &index, printItems);

    if (properties.getBool("myBool")) |val| {
        try writer.print("\nValue of \"myBool\" is {s}\n", .{if (val) "true" else "false"});
    }
    if (properties.getString("myStr")) |val| {
        try writer.print("\nValue of \"myStr\" is {s}\n", .{val}); // Will not print.
    }
}
