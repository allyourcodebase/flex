const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    // TODO: depend on an M4 implementation through build.zig.zon?
    const m4_path = b.option([]const u8, "M4", "set the path to the default M4 binary") orelse "/bin/m4";

    const flex = b.dependency("flex-generated-src", .{});

    const exe = b.addExecutable(.{
        .name = "flex",
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addCMacro("VERSION", "\"v2.6.4\""); // flex version
    exe.root_module.addCMacro("HAVE_ASSERT_H", "");
    exe.root_module.addCMacro("HAVE_LIMITS_H", "");
    exe.root_module.addCMacro("HAVE_NETINET_IN_H", "");

    exe.root_module.addCMacro("M4", b.fmt("\"{}\"", .{std.zig.fmtEscapes(m4_path)})); // path to default m4 binary

    exe.root_module.addIncludePath(flex.path("src"));
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/buf.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/ccl.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/dfa.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/ecs.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/filter.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/gen.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/main.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/misc.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/nfa.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/options.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/regex.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/scan.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/scanflags.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/scanopt.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/skel.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/sym.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/tables.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/tables_shared.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/tblcmp.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/yylex.c") });
    exe.root_module.addCSourceFile(.{ .file = flex.path("src/parse.c") });
    exe.root_module.link_libc = true;

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // // By making the run step depend on the install step, it will be run from the
    // // installation directory rather than directly from within the cache directory.
    // // This is not necessary, however, if the application depends on other installed
    // // files, this ensures they will be present and in the expected location.
    // run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
