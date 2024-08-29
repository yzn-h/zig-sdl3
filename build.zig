const std = @import("std");
const zig = @import("builtin");

pub fn build(b: *std.Build) !void {
    const cfg = std.Build.TestOptions{
        .name = "zig-sdl3",
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
        .root_source_file = std.Build.LazyPath.relative("src/sdl3.zig"),
        .version = .{
            .major = 0,
            .minor = 1,
            .patch = 0,
        },
    };
    const sdl3 = b.addModule("sdl3", .{ .source_file = cfg.root_source_file });
    _ = setupTest(b, cfg);
    _ = try setupExamples(b, sdl3, cfg);
    _ = try runExample(b, sdl3, cfg);
}

pub fn linkTarget(target: *std.Build.Step.Compile) void {
    target.addSystemIncludePath(.{ .path = "/usr/local/include" });
    target.linkSystemLibrary("SDL3");
    target.linkSystemLibrary("m");
    target.linkLibC();
}

pub fn setupExample(b: *std.Build, sdl3: *std.Build.Module, cfg: std.Build.TestOptions, name: []const u8) !*std.Build.Step.Compile {
    const exe = b.addExecutable(.{
        .name = name,
        .target = cfg.target,
        .optimize = cfg.optimize,
        .root_source_file = std.Build.LazyPath.relative(try std.fmt.allocPrint(b.allocator, "examples/{s}/main.zig", .{name})),
        .version = cfg.version,
    });
    exe.addModule("sdl3", sdl3);
    linkTarget(exe);
    b.installArtifact(exe);
    return exe;
}

pub fn runExample(b: *std.Build, sdl3: *std.Build.Module, cfg: std.Build.TestOptions) !void {
    const run_example: ?[]const u8 = b.option([]const u8, "example", "The example name for running an example") orelse null;
    const run = b.step("run", "Run an example with -Dexample=<example_name> option");
    if (run_example) |example| {
        const run_art = b.addRunArtifact(try setupExample(b, sdl3, cfg, example));
        run_art.step.dependOn(b.getInstallStep());
        run.dependOn(&run_art.step);
    }
}

pub fn setupExamples(b: *std.Build, sdl3: *std.Build.Module, cfg: std.Build.TestOptions) !*std.Build.Step {
    const exp = b.step("examples", "Build all examples");
    // _ = dir;
    _ = try setupExample(b, sdl3, cfg, "hello-world");
    return exp;
}

pub fn setupTest(b: *std.Build, cfg: std.Build.TestOptions) *std.Build.Step.Compile {
    const tst = b.addTest(cfg);
    linkTarget(tst);
    const tst_run = b.addRunArtifact(tst);
    const tst_step = b.step("test", "Run all tests");
    tst_step.dependOn(&tst_run.step);
    return tst;
}
