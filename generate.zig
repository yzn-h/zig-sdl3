const std = @import("std");
const ymlz = @import("ymlz");

const ValueData = struct {
    zigValue: []const u8,
    sdlValue: []const u8,
    comment: []const u8,
};

const Enum = struct {
    sdlType: []const u8,
    zigType: []const u8,
    comment: []const u8,
    values: []const ValueData,
};

const Error = struct {
    name: []const u8,
    comment: []const u8,
    values: [][]const u8,
};

const Function = struct {
    sdlName: []const u8,
    zigName: []const u8,
    comment: []const u8,
    ret: struct {
        sdl: []const u8,
        zig: []const u8,
        convert: []const u8,
        checks: []const struct {
            method: []const u8,
            comparisonVal: []const u8,
        },
    },
    arguments: []const struct {
        name: []const u8,
        type: []const u8,
        value: []const u8,
    },
};

const Value = struct {
    type: []const u8,
    name: []const u8,
    isOpaque: bool,
    comment: []const u8,
    presets: []const ValueData,
    functions: []const Function,
};

const Flag = struct {
    name: []const u8,
    type: []const u8,
    comment: []const u8,
    values: []const struct {
        name: []const u8,
        type: []const u8,
        value: []const u8,
        comment: []const u8,
    },
    presets: []const struct {
        name: []const u8,
        comment: []const u8,
        values: []const struct {
            name: []const u8,
            value: bool,
        },
    },
};

const StringMap = struct {
    name: []const u8,
    comment: []const u8,
    values: []const ValueData,
};

const Struct = struct {
    name: []const u8,
    type: []const u8,
    comment: []const u8,
    members: []const struct {
        zigName: []const u8,
        sdlName: []const u8,
        type: []const u8,
        value: []const u8,
        comment: []const u8,
    },
    functions: []const Function,
    customFunctions: []const struct {
        code: []const u8,
    },
};

const Test = struct {
    name: []const u8,
    comment: []const u8,
    code: []const u8,
};

const Subsystem = struct {
    name: []const u8,
    callbacks: []const Function,
    enums: []const Enum,
    errors: []const Error,
    values: []const Value,
    flags: []const Flag,
    stringMap: []const StringMap,
    structs: []const Struct,
    functions: []const Function,
    customFunctions: []const struct {
        code: []const u8,
    },
    tests: []const Test,
};

const Bindings = struct {
    subsystems: []const Subsystem,
};

const WriteError = error{InvalidEnumValue};

const SdlType = enum {
    Callback,
    Enum,
    Value,
    Flag,
    StringMap,
};

const SdlTypeData = union(SdlType) {
    Callback: struct {
        func: Function,
        name: []const u8,
    },
    Enum: Enum,
    Value: Value,
    Flag: Flag,
    StringMap: StringMap,
};

const GeneratorError = error{
    UnknownSdlToTrueSdlType,
    UnknownSdlToZigType,
    UnknownZigValueToSdlValue,
    UnknownSdlValueToZigValue,
    UnknownComparisonType,
    UnknownReturnCheck,
};

fn sdlTypeToTrueSdlType(sdl: []const u8, sdl_types: std.StringHashMap(SdlTypeData), generics: std.StringHashMap(void)) ![]const u8 {
    _ = sdl_types;

    // String.
    if (std.mem.eql(u8, sdl, "string") or std.mem.eql(u8, sdl, "stringptr") or std.mem.eql(u8, sdl, "?string") or std.mem.eql(u8, sdl, "zigstring") or std.mem.eql(u8, sdl, "?zigstring"))
        return "[*c]const u8";

    // Any opaque.
    if (std.mem.eql(u8, sdl, "*void"))
        return "?*anyopaque";

    // Void.
    if (std.mem.eql(u8, sdl, "void"))
        return "void";

    // Size pointer.
    if (std.mem.eql(u8, sdl, "*usize"))
        return "*usize";

    // Generics.
    if (generics.get(sdl)) |_|
        return "?*anyopaque";
    if (generics.get(sdl[1..])) |_| // Pointer or whatever
        return "?*anyopaque";

    // Idk.
    std.debug.print("Type: {s}\n", .{sdl});
    return error.UnknownSdlToTrueSdlType;
}

fn sdlTypeToZigType(allocator: std.mem.Allocator, sdl: []const u8, sdl_types: std.StringHashMap(SdlTypeData), generics: std.StringHashMap(void), generics_opaque: bool) ![]const u8 {

    // String type, is just simply a null-terminated zig string.
    if (std.mem.eql(u8, sdl, "string") or std.mem.eql(u8, sdl, "stringptr"))
        return "[:0]const u8";

    // Optional string type.
    if (std.mem.eql(u8, sdl, "?string"))
        return "?[:0]const u8";

    // Zig string type.
    if (std.mem.eql(u8, sdl, "zigstring"))
        return "[]const u8";

    // Optional zig string type.
    if (std.mem.eql(u8, sdl, "?zigstring"))
        return "?[]const u8";

    // Int.
    if (std.mem.eql(u8, sdl, "int"))
        return "i32";

    // Zig int.
    if (std.mem.eql(u8, sdl, "u8"))
        return "u8";

    // Type.
    if (std.mem.eql(u8, sdl, "type"))
        return "type";

    // Generics.
    if (generics.get(sdl) != null or generics.get(sdl[1..]) != null)
        return if (generics_opaque) "?*anyopaque" else sdl;

    // Go through SDL types.
    if (sdl_types.get(sdl)) |sdl_type| {
        return switch (sdl_type) {
            .Callback => |cb| try std.fmt.allocPrint(allocator, "{s}(UserData)", .{cb.func.zigName}),
            .Enum => |en| en.zigType,
            .Value => |val| val.name,
            .Flag => |flag| flag.name,
            .StringMap => sdl,
        };
    }

    // Idk.
    std.debug.print("Type: {s}\n", .{sdl});
    return error.UnknownSdlToZigType;
}

fn convertZigValueToSdl(allocator: std.mem.Allocator, val: []const u8, sdlType: []const u8, sdl_types: std.StringHashMap(SdlTypeData), indent: usize) ![]const u8 {

    // String type, just return value as it is.
    if (std.mem.eql(u8, sdlType, "string"))
        return val;

    // String type, but we want the pointer this time.
    if (std.mem.eql(u8, sdlType, "stringptr"))
        return std.fmt.allocPrint(allocator, "{s}.ptr", .{val});

    // Optional string type.
    if (std.mem.eql(u8, sdlType, "?string"))
        return std.fmt.allocPrint(allocator, "if ({s}) |str_capture| str_capture.ptr else null", .{val});

    // Int, just cast it.
    if (std.mem.eql(u8, sdlType, "int") or std.mem.eql(u8, sdlType, "u8"))
        return std.fmt.allocPrint(allocator, "@intCast({s})", .{val});

    // Go through SDL types.
    if (sdl_types.get(sdlType)) |sdl_type| {
        return switch (sdl_type) {
            .Callback => |cb| cb.name,
            .Enum => std.fmt.allocPrint(allocator, "@intFromEnum({s})", .{val}),
            .Value => std.fmt.allocPrint(allocator, "{s}.value", .{val}),
            .Flag => std.fmt.allocPrint(allocator, "{s}.toSdl()", .{val}),
            .StringMap => |map| {

                // switch (<name>) {
                //  .<zigValue> => C.<sdlValue>,
                // }
                var ret = try std.fmt.allocPrint(allocator, "switch ({s}) {{ ", .{val});
                for (map.values) |map_val| {
                    ret = try std.fmt.allocPrint(allocator, "{s}\n", .{ret});
                    for (0..indent + 1) |_| {
                        ret = try std.fmt.allocPrint(allocator, "{s}\t", .{ret});
                    }
                    ret = try std.fmt.allocPrint(allocator, "{s}.{s} => C.{s}, ", .{ ret, map_val.zigValue, map_val.sdlValue });
                }
                if (map.values.len > 0) {
                    ret = try std.fmt.allocPrint(allocator, "{s}\n", .{ret});
                    for (0..indent) |_| {
                        ret = try std.fmt.allocPrint(allocator, "{s}\t", .{ret});
                    }
                }
                return try std.fmt.allocPrint(allocator, "{s}}}", .{ret});
            },
        };
    }

    // Idk.
    std.debug.print("Val: {s}\n", .{val});
    return error.UnknownZigValueToSdlValue;
}

fn convertSdlValueToZig(allocator: std.mem.Allocator, val: []const u8, sdlType: []const u8, sdl_types: std.StringHashMap(SdlTypeData), convert: []const u8) ![]const u8 {

    // Custom convert mode.
    if (!std.mem.eql(u8, convert, "null"))
        return convert;

    // If converting from a string, just take a span.
    if (std.mem.eql(u8, sdlType, "string") or std.mem.eql(u8, sdlType, "?string") or std.mem.eql(u8, sdlType, "zigstring"))
        return std.fmt.allocPrint(allocator, "std.mem.span({s})", .{val});

    // Optional zig string, it may be null.
    if (std.mem.eql(u8, sdlType, "?zigstring"))
        return std.fmt.allocPrint(allocator, "if ({s} == null) null else std.mem.span({s})", .{ val, val });

    // Bool, simple enough.
    if (std.mem.eql(u8, sdlType, "bool"))
        return val;

    // Int, just cast it.
    if (std.mem.eql(u8, sdlType, "int") or std.mem.eql(u8, sdlType, "u8"))
        return std.fmt.allocPrint(allocator, "@intCast({s})", .{val});

    // Void pointer idk.
    if (std.mem.eql(u8, sdlType, "*void"))
        return val;

    // Go through SDL types.
    if (sdl_types.get(sdlType)) |sdl_type| {
        return switch (sdl_type) {
            .Callback => val,
            .Enum => std.fmt.allocPrint(allocator, "@enumFromInt({s})", .{val}),
            .Value => |v| if (v.isOpaque) std.fmt.allocPrint(allocator, "{s}{{ .value = {s}.? }}", .{ v.name, val }) else std.fmt.allocPrint(allocator, "{s}{{ .value = {s} }}", .{ v.name, val }),
            .Flag => |flag| std.fmt.allocPrint(allocator, "{s}.fromSdl({s})", .{ flag.name, val }),
            .StringMap => std.fmt.allocPrint(allocator, "std.mem.span({s})", .{val}),
        };
    }

    // Idk.
    std.debug.print("Val: {s}, Type: {s}\n", .{ val, sdlType });
    return error.UnknownSdlValueToZigValue;
}

fn writeReturnConversions(allocator: std.mem.Allocator, writer: std.io.AnyWriter, func: Function, indent: usize, ret_used: *bool) !bool {
    var converted_ret = false;
    for (func.ret.checks) |check| {

        // Custom method.
        if (std.mem.eql(u8, check.method, "Custom")) {
            try nextLine(writer, indent + 1);
            try writer.writeAll(check.comparisonVal);
            ret_used.* = true;
        }

        // Returns null if SDL value matches comparison value.
        else if (std.mem.eql(u8, check.method, "ReturnNullIfEqStr")) {

            // const converted_ret = std.mem.span(ret);
            // if (std.mem.eql(u8, converted_ret, <comparisonVal>))
            //  return null;
            try nextLine(writer, indent + 1);
            try writer.writeAll("const converted_ret = std.mem.span(ret);");
            try nextLine(writer, indent + 1);
            try writer.print("if (std.mem.eql(u8, converted_ret, {s}))", .{check.comparisonVal});
            try nextLine(writer, indent + 2);
            try writer.writeAll("return null;");
            converted_ret = true;
        }

        // Raw comparison value.
        else if (std.mem.eql(u8, check.method, "ReturnNullIfEq")) {

            // if (ret == <comparisonVal>)
            //  return null;
            try nextLine(writer, indent + 1);
            try writer.print(
                "if (ret == {s})",
                .{try std.mem.replaceOwned(u8, allocator, check.comparisonVal, "$SDL", "C")},
            );
            try nextLine(writer, indent + 2);
            try writer.writeAll("return null;");
            ret_used.* = true;
        }

        // Returns null if SDL value matches comparison value.
        else if (std.mem.eql(u8, check.method, "ReturnErrIfEqStr")) {

            // const converted_ret = std.mem.span(ret);
            // if (std.mem.eql(u8, converted_ret, <comparisonVal>))
            //  return null;
            try nextLine(writer, indent + 1);
            try writer.writeAll("const converted_ret = std.mem.span(ret);");
            try nextLine(writer, indent + 1);
            try writer.print("if (std.mem.eql(u8, converted_ret, {s}))", .{check.comparisonVal});
            try nextLine(writer, indent + 2);
            try writer.writeAll("return error.SdlError;");
            converted_ret = true;
        }

        // Returns error if SDL value matches comparison value.
        else if (std.mem.eql(u8, check.method, "ReturnErrIfEq")) {

            // Comparison type is bool. Self explanatory.
            if (std.mem.eql(u8, func.ret.sdl, "bool")) {

                // if (ret)
                //  return error.SdlError;
                try nextLine(writer, indent + 1);
                if (std.mem.eql(u8, check.comparisonVal, "true")) {
                    try writer.writeAll("if (ret)");
                } else try writer.writeAll("if (!ret)");
                try nextLine(writer, indent + 2);
                try writer.writeAll("return error.SdlError;");
                ret_used.* = true;
            }

            // Just compare raw value.
            else {

                // if (ret == <comparisonVal>)
                //  return error.SdlError;
                try nextLine(writer, indent + 1);
                try writer.print(
                    "if (ret == {s})",
                    .{try std.mem.replaceOwned(u8, allocator, check.comparisonVal, "$SDL", "C")},
                );
                try nextLine(writer, indent + 2);
                try writer.writeAll("return error.SdlError;");
                ret_used.* = true;
            }
        }

        // Not handled.
        else {
            return error.UnknownReturnCheck;
        }
    }
    return converted_ret;
}

fn nextLine(writer: std.io.AnyWriter, indent: usize) !void {
    try writer.writeAll("\n");
    for (0..indent) |_| {
        try writer.writeAll("\t");
    }
}

fn writeEnum(writer: std.io.AnyWriter, en: Enum, indent: usize) !void {

    //
    // /// <comment>
    // pub const <zigType> = enum(c_uint) {
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{en.comment});
    try nextLine(writer, indent);
    try writer.print("pub const {s} = enum(c_uint) {{", .{en.zigType});

    // /// <comment>
    // <zigValue> = C.<sdlValue>,
    for (en.values) |val| {

        // Comment only if present.
        if (!std.mem.eql(u8, val.comment, "null")) {
            try nextLine(writer, indent + 1);
            try writer.print("/// {s}", .{val.comment});
        }

        // Write value.
        try nextLine(writer, indent + 1);
        try writer.print("{s} = C.{s},", .{ val.zigValue, val.sdlValue });
    }

    // };
    try nextLine(writer, indent);
    try writer.writeAll("};");
}

fn writeError(writer: std.io.AnyWriter, err: Error, indent: usize) !void {

    //
    // /// <comment>
    // pub const <name> = error{
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{err.comment});
    try nextLine(writer, indent);
    try writer.print("pub const {s} = error{{", .{err.name});

    // <val>,
    for (err.values) |val| {
        try nextLine(writer, indent + 1);
        try writer.print("{s},", .{val});
    }

    // };
    try nextLine(writer, indent);
    try writer.writeAll("};");
}

fn writeValue(allocator: std.mem.Allocator, writer: std.io.AnyWriter, val: Value, indent: usize, sdl_types: std.StringHashMap(SdlTypeData)) !void {

    //
    // /// <comment>
    // pub const <name> = struct {
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{val.comment});
    try nextLine(writer, indent);
    try writer.print("pub const {s} = struct {{", .{val.name});

    // value: C.<type>,
    try nextLine(writer, indent + 1);
    if (val.isOpaque) {
        try writer.print("value: *C.{s},", .{val.type});
    } else try writer.print("value: C.{s},", .{val.type});

    // /// <comment>
    // pub const <zigValue> = <name> { .value = <sdlValue> };
    for (val.presets) |preset| {
        if (!std.mem.eql(u8, val.comment, "null")) {
            try nextLine(writer, indent + 1);
            try writer.print("/// {s}", .{preset.comment});
        }
        try nextLine(writer, indent + 1);
        try writer.writeAll(try std.mem.replaceOwned(
            u8,
            allocator,
            try std.fmt.allocPrint(allocator, "pub const {s} = {s}{{ .value = {s} }};", .{ preset.zigValue, val.name, preset.sdlValue }),
            "$SDL",
            "C",
        ));
    }

    // <function>
    for (val.functions) |func| {
        try writeFunction(allocator, writer, func, indent + 1, sdl_types);
    }

    // };
    try nextLine(writer, indent);
    try writer.writeAll("};");
}

fn writeFlag(allocator: std.mem.Allocator, writer: std.io.AnyWriter, flag: Flag, indent: usize) !void {
    _ = allocator;

    //
    // /// <comment>
    // pub const <name> = struct {
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{flag.comment});
    try nextLine(writer, indent);
    try writer.print("pub const {s} = struct {{", .{flag.name});

    // /// <comment>
    // <name>: bool = <value>,
    for (flag.values) |val| {
        if (!std.mem.eql(u8, val.comment, "null")) {
            try nextLine(writer, indent + 1);
            try writer.print("/// {s}", .{val.comment});
        }
        try nextLine(writer, indent + 1);
        try writer.print("{s}: bool", .{val.name});
        if (!std.mem.eql(u8, val.value, "null"))
            try writer.print(" = {s}", .{val.value});
        try writer.writeAll(",");
    }

    // /// <comment>
    // pub const <name> = <type>{
    //  .<name> = <value>,
    // };
    for (flag.presets) |preset| {
        if (!std.mem.eql(u8, preset.comment, "null")) {
            try nextLine(writer, indent + 1);
            try writer.print("/// {s}", .{preset.comment});
        }
        try nextLine(writer, indent + 1);
        try writer.print("pub const {s} = {s}{{", .{ preset.name, flag.name });
        for (preset.values) |val| {
            try nextLine(writer, indent + 2);
            try writer.print(".{s} = {s},", .{ val.name, if (val.value) "true" else "false" });
        }
        try nextLine(writer, indent + 1);
        try writer.writeAll("};");
    }

    // pub fn fromSdl(flags: C.<type>) <name> {
    //  return .{
    //      .<name> = (flags & C.<type>) != 0,
    //  };
    // }
    try nextLine(writer, 0);
    try nextLine(writer, indent + 1);
    try writer.writeAll("/// Convert from an SDL value.");
    try nextLine(writer, indent + 1);
    try writer.print("pub fn fromSdl(flags: C.{s}) {s} {{", .{ flag.type, flag.name });
    try nextLine(writer, indent + 2);
    try writer.writeAll("return .{");
    for (flag.values) |val| {
        try nextLine(writer, indent + 3);
        try writer.print(".{s} = (flags & C.{s}) != 0,", .{ val.name, val.type });
    }
    try nextLine(writer, indent + 2);
    try writer.writeAll("};");
    try nextLine(writer, indent + 1);
    try writer.writeAll("}");

    // pub fn toSdl(self: <name>) <type> {
    //  return
    //      (if (self.<name>) @as(C.<type>, C.<type>) else 0) |
    //      0;
    // }
    try nextLine(writer, 0);
    try nextLine(writer, indent + 1);
    try writer.writeAll("/// Convert to an SDL value.");
    try nextLine(writer, indent + 1);
    try writer.print("pub fn toSdl(self: {s}) C.{s} {{", .{ flag.name, flag.type });
    try nextLine(writer, indent + 2);
    try writer.writeAll("return ");
    for (flag.values, 0..) |val, ind| {
        if (ind != 0)
            try nextLine(writer, indent + 3);
        try writer.print("(if (self.{s}) @as(C.{s}, C.{s}) else 0) |", .{ val.name, flag.type, val.type });
    }
    try nextLine(writer, indent + 3);
    try writer.writeAll("0;");
    try nextLine(writer, indent + 1);
    try writer.writeAll("}");

    // };
    try nextLine(writer, indent);
    try writer.writeAll("};");
}

fn writeMap(writer: std.io.AnyWriter, map: StringMap, indent: usize) !void {

    //
    // /// <comment>
    // pub const <zigType> = enum {
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{map.comment});
    try nextLine(writer, indent);
    try writer.print("pub const {s} = enum {{", .{map.name});

    // /// <comment>
    // <zigValue> = C.<sdlValue>,
    for (map.values) |val| {

        // Comment only if present.
        if (!std.mem.eql(u8, val.comment, "null")) {
            try nextLine(writer, indent + 1);
            try writer.print("/// {s}", .{val.comment});
        }

        // Write value.
        try nextLine(writer, indent + 1);
        try writer.print("{s},", .{val.zigValue});
    }

    // };
    try nextLine(writer, indent);
    try writer.writeAll("};");
}

fn writeStruct(allocator: std.mem.Allocator, writer: std.io.AnyWriter, st: Struct, indent: usize, sdl_types: std.StringHashMap(SdlTypeData)) !void {

    //
    // /// <comment>
    // pub const <name> = struct {
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{st.comment});
    try nextLine(writer, indent);
    try writer.print("pub const {s} = struct {{", .{st.name});

    // /// <comment>
    // <name>: <type> = <value>,
    const generics = std.StringHashMap(void).init(allocator);
    for (st.members) |member| {

        // Comment only if present.
        if (!std.mem.eql(u8, member.comment, "null")) {
            try nextLine(writer, indent + 1);
            try writer.print("/// {s}", .{member.comment});
        }

        // Write member.
        try nextLine(writer, indent + 1);
        if (!std.mem.eql(u8, member.value, "null")) {
            try writer.print("{s}: {s} = {s},", .{ member.zigName, try sdlTypeToZigType(allocator, member.type, sdl_types, generics, true), member.value });
        } else try writer.print("{s}: {s},", .{ member.zigName, try sdlTypeToZigType(allocator, member.type, sdl_types, generics, true) });
    }

    // pub fn fromSdl(data: C.<type>) <name> {
    //  return .{
    //      .<name> = <convert data.<name>>,
    //  };
    // }
    try nextLine(writer, 0);
    try nextLine(writer, indent + 1);
    try writer.writeAll("/// Convert from an SDL value.");
    try nextLine(writer, indent + 1);
    try writer.print("pub fn fromSdl(data: C.{s}) {s} {{", .{ st.type, st.name });
    try nextLine(writer, indent + 2);
    try writer.writeAll("return .{");
    for (st.members) |member| {
        try nextLine(writer, indent + 3);
        try writer.print(".{s} = {s},", .{ member.zigName, try convertSdlValueToZig(
            allocator,
            try std.fmt.allocPrint(allocator, "data.{s}", .{member.sdlName}),
            member.type,
            sdl_types,
            "null",
        ) });
    }
    try nextLine(writer, indent + 2);
    try writer.writeAll("};");
    try nextLine(writer, indent + 1);
    try writer.writeAll("}");

    // pub fn toSdl(self: <name>) C.<type> {
    //  return .{
    //      .<name> = <convert self.<name>>,
    //  };
    // }
    try nextLine(writer, 0);
    try nextLine(writer, indent + 1);
    try writer.writeAll("/// Convert to an SDL value.");
    try nextLine(writer, indent + 1);
    try writer.print("pub fn toSdl(self: {s}) C.{s} {{", .{ st.name, st.type });
    try nextLine(writer, indent + 2);
    try writer.writeAll("return .{");
    for (st.members) |member| {
        try nextLine(writer, indent + 3);
        try writer.print(".{s} = {s},", .{ member.sdlName, try convertZigValueToSdl(
            allocator,
            try std.fmt.allocPrint(allocator, "self.{s}", .{member.sdlName}),
            member.type,
            sdl_types,
            indent + 2,
        ) });
    }
    try nextLine(writer, indent + 2);
    try writer.writeAll("};");
    try nextLine(writer, indent + 1);
    try writer.writeAll("}");

    // Write functions.
    for (st.functions) |func| {
        try writeFunction(allocator, writer, func, indent + 1, sdl_types);
    }
    for (st.customFunctions) |func| {
        try nextLine(writer, 0);
        try nextLine(writer, indent + 1);
        try writer.writeAll(func.code);
    }

    // };
    try nextLine(writer, indent);
    try writer.writeAll("};");
}

// Hard to grasp, so below is an example:
//
// pub fn DataCallback(
// 	comptime UserData: type,
// ) type {
// 	return *const fn (
// 		user_data: *UserData,
// 		mime_type: [:0]const u8,
// 	) []const u8;
// }

// const DataCallbackData = struct {
//  cb: *const fn (
//      user_data: ?*anyopaque,
//      mime_type: []const u8
//  ) []const u8,
//  data: ?*anyopaque,
// };

// fn dataCallback(
// 	user_data: ?*anyopaque,
// 	mime_type: [*c]const u8,
// 	size: *usize,
// ) callconv(.C) []const u8 {
//     const cb_data: *DataCallbackData = @ptrCast(@alignCast(user_data));
//     const ret = cb_data.cb(
//      cb_data.data,
//      std.mem.span(mime_type)
//     );
//     *size = ret.len;
//     return ret.ptr;
// }
fn writeCallback(allocator: std.mem.Allocator, writer: std.io.AnyWriter, func: Function, indent: usize, sdl_types: std.StringHashMap(SdlTypeData)) !void {

    //
    // <comment>
    // pub fn <zigName>(
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{func.comment});
    try nextLine(writer, indent);
    try writer.print("pub fn {s}(", .{func.zigName});

    // comptime <name>: type
    var type_cnt: usize = 0;
    var generics = std.StringHashMap(void).init(allocator);
    for (func.arguments) |arg| {
        if (std.mem.eql(u8, arg.type, "type")) {
            try nextLine(writer, indent + 1);
            try writer.print("comptime {s}: type,", .{arg.name});
            try generics.put(arg.name, {});
            type_cnt += 1;
        }
    }
    if (type_cnt > 0)
        try nextLine(writer, indent);

    // ) type {
    try writer.writeAll(") type {");

    //  return *const fn(
    try nextLine(writer, indent + 1);
    try writer.writeAll("return *const fn (");

    // <name>: <type>,
    type_cnt = 0;
    for (func.arguments) |arg| {
        if (!std.mem.eql(u8, arg.type, "type") and std.mem.eql(u8, arg.value, "null")) {
            try nextLine(writer, indent + 2);
            try writer.print("{s}: {s},", .{ arg.name, try sdlTypeToZigType(allocator, arg.type, sdl_types, generics, false) });
            type_cnt += 1;
        }
    }
    if (type_cnt > 0)
        try nextLine(writer, indent + 1);

    //  ) <return>;
    // }
    try writer.print(") {s};", .{func.ret.zig});
    try nextLine(writer, indent);
    try writer.writeAll("}");

    //
    // /// <comment>
    // pub const <zigName>Data = struct {
    //  cb: *const fn (
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{func.comment});
    try nextLine(writer, indent);
    try writer.print("pub const {s}Data = struct {{", .{func.zigName});
    try nextLine(writer, indent + 1);
    try writer.writeAll("cb: *const fn (");

    // <name: <type>,
    type_cnt = 0;
    for (func.arguments) |arg| {
        if (!std.mem.eql(u8, arg.type, "type") and std.mem.eql(u8, arg.value, "null")) {
            try nextLine(writer, indent + 2);
            try writer.print("{s}: {s},", .{ arg.name, try sdlTypeToZigType(allocator, arg.type, sdl_types, generics, true) });
            type_cnt += 1;
        }
    }
    if (type_cnt > 0)
        try nextLine(writer, indent + 1);

    //  ) <ret>,
    //  data: ?*anyopaque,
    // };
    try writer.print(") {s},", .{func.ret.zig});
    try nextLine(writer, indent + 1);
    try writer.writeAll("data: ?*anyopaque,");
    try nextLine(writer, indent);
    try writer.writeAll("};");

    //
    // /// <comment>
    // pub fn <zigName>(
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{func.comment});
    try nextLine(writer, indent);
    var c_name = try allocator.alloc(u8, func.zigName.len);
    @memcpy(c_name, func.zigName);
    c_name[0] = std.ascii.toLower(c_name[0]);
    try writer.print("pub fn {s}(", .{c_name});

    // <name>: <type>
    for (func.arguments) |arg| {
        if (!std.mem.eql(u8, arg.type, "type")) {
            try nextLine(writer, indent + 1);
            try writer.print("{s}: {s},", .{ arg.name, try sdlTypeToTrueSdlType(arg.type, sdl_types, generics) });
        }
    }
    if (func.arguments.len > 0)
        try nextLine(writer, indent);

    // ) callconv(.C) <return> {
    try writer.print(") callconv(.C) {s} {{", .{try sdlTypeToTrueSdlType(func.ret.sdl, sdl_types, generics)});

    // const cb_data: *<zigName>Data = @ptrCast(@alignCast(<firstGeneric>));
    var first_generic_type: ?[]const u8 = null;
    var first_generic_type_ptr: []const u8 = undefined;
    var first_generic_name: []const u8 = undefined;
    for (func.arguments) |arg| {
        if (first_generic_type == null and std.mem.eql(u8, arg.type, "type")) {
            first_generic_type = arg.type;
            first_generic_type_ptr = try std.fmt.allocPrint(allocator, "*{s}", .{arg.name});
        } else if (first_generic_type != null and std.mem.eql(u8, arg.type, first_generic_type_ptr)) {
            first_generic_name = arg.name;
            break;
        }
    }
    try nextLine(writer, indent + 1);
    try writer.print("const cb_data: *{s}Data = @ptrCast(@alignCast({s}));", .{ func.zigName, first_generic_name });

    // const ret = cb_data.cb(
    try nextLine(writer, indent + 1);
    try writer.writeAll("const ret = cb_data.cb(");

    // <argValue>,
    for (func.arguments) |arg| {
        if (!std.mem.eql(u8, arg.type, "type")) {

            // Generic test.
            if (generics.get(arg.type) != null or generics.get(arg.type[1..]) != null) {

                // Is the first generic type.
                if (std.mem.eql(u8, arg.type, first_generic_type_ptr)) {
                    try nextLine(writer, indent + 2);
                    try writer.writeAll("cb_data.data,");
                } else {
                    return error.UnknownSdlValueToZigValue;
                }
            } else {
                if (std.mem.eql(u8, arg.value, "null")) {
                    try nextLine(writer, indent + 2);
                    try writer.print("{s},", .{try convertSdlValueToZig(allocator, arg.name, arg.type, sdl_types, "null")});
                }
            }
        }
    }
    if (func.arguments.len > 0)
        try nextLine(writer, indent + 1);

    // );
    try writer.writeAll(");");

    // Write each conversion, depends on type.
    var ret_used = false;
    const converted_ret = try writeReturnConversions(allocator, writer, func, indent, &ret_used);

    // Return if not a void type.
    if (!std.mem.eql(u8, func.ret.zig, "void") and !std.mem.eql(u8, func.ret.zig, "!void")) {

        // return <convert ret>;
        try nextLine(writer, indent + 1);
        if (converted_ret) {
            try writer.writeAll("return converted_ret;");
        } else try writer.print("return {s};", .{
            try convertSdlValueToZig(allocator, "ret", func.ret.sdl, sdl_types, func.ret.convert),
        });
        ret_used = true;
    }

    // Discard original value entirely.
    if (!ret_used) {

        // _ = ret;
        try nextLine(writer, indent + 1);
        try writer.writeAll("_ = ret;");
    }

    // }
    try nextLine(writer, indent);
    try writer.writeAll("}");
}

fn writeFunction(allocator: std.mem.Allocator, writer: std.io.AnyWriter, func: Function, indent: usize, sdl_types: std.StringHashMap(SdlTypeData)) !void {

    //
    // /// <comment>
    // pub fn <zigName>(
    try nextLine(writer, 0);
    try nextLine(writer, indent);
    try writer.print("/// {s}", .{func.comment});
    try nextLine(writer, indent);
    try writer.print("pub fn {s}(", .{func.zigName});

    // <argName>: <argType>,
    var generics = std.StringHashMap(void).init(allocator);
    var num_args: usize = 0;
    for (func.arguments) |arg| {
        if (std.mem.eql(u8, arg.value, "null")) {
            try nextLine(writer, indent + 1);
            try writer.print("{s}: {s},", .{ arg.name, try sdlTypeToZigType(allocator, arg.type, sdl_types, generics, false) });
            num_args += 1;
        }
        if (std.mem.eql(u8, arg.type, "type")) {
            try generics.put(arg.name, {});
            num_args += 1;
        }
    }
    if (num_args > 0)
        try nextLine(writer, indent);

    // ) <retZig> {
    try writer.print(") {s} {{", .{func.ret.zig});

    // var <argName>: <argType> = undefined;
    for (func.arguments) |arg| {
        if (arg.value[0] == '&') {
            try nextLine(writer, indent + 1);
            try writer.print("var {s}: {s} = undefined;", .{ arg.name, arg.type });
        }
    }

    // const ret = C.<sdlName>(
    try nextLine(writer, indent + 1);
    try writer.print("const ret = C.{s}(", .{func.sdlName});
    var ret_used = false;

    // <argValue>,
    num_args = 0;
    for (func.arguments) |arg| {
        if (std.mem.eql(u8, arg.type, "type") or generics.get(arg.type) != null or generics.get(arg.type[1..]) != null)
            continue;
        try nextLine(writer, indent + 2);
        try writer.print("{s},", .{
            if (std.mem.eql(u8, arg.value, "null")) try convertZigValueToSdl(allocator, arg.name, arg.type, sdl_types, indent + 2) else arg.value,
        });
        num_args += 1;
    }

    // );
    if (num_args > 0)
        try nextLine(writer, indent + 1);
    try writer.writeAll(");");

    // Write each conversion, depends on type.
    const converted_ret = try writeReturnConversions(allocator, writer, func, indent, &ret_used);

    // Return if not a void type.
    if (!std.mem.eql(u8, func.ret.zig, "void") and !std.mem.eql(u8, func.ret.zig, "!void")) {

        // return <convert ret>;
        try nextLine(writer, indent + 1);
        if (converted_ret) {
            try writer.writeAll("return converted_ret;");
        } else try writer.print("return {s};", .{
            try convertSdlValueToZig(allocator, "ret", func.ret.sdl, sdl_types, func.ret.convert),
        });
        ret_used = true;
    }

    // Discard original value entirely.
    if (!ret_used) {

        // _ = ret;
        try nextLine(writer, indent + 1);
        try writer.writeAll("_ = ret;");
    }

    // }
    try nextLine(writer, indent);
    try writer.writeAll("}");
}

fn writeTest(allocator: std.mem.Allocator, writer: std.io.AnyWriter, t: Test) !void {
    try nextLine(writer, 0);
    try writer.print(
        \\
        \\// {s}
        \\test "{s}" {{
        \\
    ++ "\t", .{ t.comment, t.name });
    try writer.writeAll(try std.mem.replaceOwned(u8, allocator, t.code[0 .. t.code.len - 1], "\n", "\n\t"));
    try writer.print(
        \\
        \\}}
        \\
    , .{});
}

pub fn main() !void {

    // We are using an arena so no freeing is necessary other than freeing the arena itself.
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Load the bindings YAML file. Don't worry, if it's formatted incorrectly the program will randomly segfault (it's a ymlz thing).
    var yml = try ymlz.Ymlz(Bindings).init(allocator);
    const result = try yml.loadFile(try std.fs.cwd().realpathAlloc(allocator, "bindings.yaml"));

    // Fetch SDL types.
    var sdl_types = std.StringHashMap(SdlTypeData).init(allocator);
    for (result.subsystems) |subsystem| {
        for (subsystem.callbacks) |cb| {
            var name = try allocator.alloc(u8, cb.zigName.len);
            @memcpy(name, cb.zigName);
            name[0] = std.ascii.toLower(name[0]);
            try sdl_types.put(cb.sdlName, SdlTypeData{ .Callback = .{
                .func = cb,
                .name = name,
            } });
        }
        for (subsystem.enums) |en| {
            try sdl_types.put(en.sdlType, SdlTypeData{ .Enum = en });
        }
        for (subsystem.values) |val| {
            try sdl_types.put(val.type, SdlTypeData{ .Value = val });
        }
        for (subsystem.flags) |flag| {
            try sdl_types.put(flag.type, SdlTypeData{ .Flag = flag });
        }
        for (subsystem.stringMap) |map| {
            try sdl_types.put(map.name, SdlTypeData{ .StringMap = map });
        }
        // for (subsystem.structs) |st| {
        // try sdl_types.put(st.type, SdlTypeData{ .Struct });
        // }
    }

    // Recreate generated folder.
    std.fs.cwd().deleteTree("src") catch {};
    try std.fs.cwd().makeDir("src");
    const dir = try std.fs.cwd().openDir("src", .{});

    // Open main library file and generate subsystems.
    const sdl_file = try dir.createFile("sdl3.zig", .{ .truncate = true });
    for (result.subsystems) |subsystem| {
        const file = try dir.createFile(try std.fmt.allocPrint(
            allocator,
            "{s}.zig",
            .{subsystem.name},
        ), .{ .truncate = true });
        defer file.close();

        // Write base data.
        const writer = file.writer().any();
        try writer.writeAll("// This file was generated using `zig build bindings`. Do not manually edit!\n\nconst C = @import(\"c.zig\").C;\nconst std = @import(\"std\");");
        for (subsystem.callbacks) |cb| {
            try writeCallback(allocator, writer, cb, 0, sdl_types);
        }
        for (subsystem.enums) |en| {
            try writeEnum(writer, en, 0);
        }
        for (subsystem.errors) |err| {
            try writeError(writer, err, 0);
        }
        for (subsystem.values) |val| {
            try writeValue(allocator, writer, val, 0, sdl_types);
        }
        for (subsystem.flags) |flag| {
            try writeFlag(allocator, writer, flag, 0);
        }
        for (subsystem.stringMap) |map| {
            try writeMap(writer, map, 0);
        }
        for (subsystem.structs) |st| {
            try writeStruct(allocator, writer, st, 0, sdl_types);
        }
        for (subsystem.functions) |func| {
            try writeFunction(allocator, writer, func, 0, sdl_types);
        }
        for (subsystem.customFunctions) |func| {
            try nextLine(writer, 0);
            try nextLine(writer, 0);
            try writer.writeAll(func.code);
        }
        for (subsystem.tests) |t| {
            try writeTest(allocator, writer, t);
        }
        try nextLine(writer, 0);

        // Add import to main file.
        try sdl_file.writer().print("pub const {s} = @import(\"{s}.zig\");\n", .{ subsystem.name, subsystem.name });
    }

    // C bindings.
    const c_file = try dir.createFile("c.zig", .{ .truncate = true });
    try c_file.writer().writeAll("pub const C = @cImport(@cInclude(\"SDL3/SDL.h\"));\n");

    // Rest of main file.
    try sdl_file.writer().writeAll(
        \\
        \\pub const C = @import("c.zig").C;
        \\
        \\const std = @import("std");
        \\
        \\/// Free memory allocated with SDL. For slices, pass in the pointer.
        \\pub fn free(mem: ?*anyopaque) void {
        \\    C.SDL_free(mem);
        \\}
        \\
        \\test {
        \\    std.testing.refAllDecls(@This());
        \\}
        \\
    );
}
