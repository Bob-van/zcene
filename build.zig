const std = @import("std");

// Just a showcase of requirements to build on said platforms (feel free to swap for other cpu architectures):
// zig build -Dtarget=x86_64-windows
// zig build -Dtarget=x86_64-linux-gnu.2.38 --search-prefix /usr
// zig build -Dtarget=aarch64-macos
// zig build -Dtarget=x86_64-macos

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("zcene", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });

    if (target.result.os.tag == .macos) { //TO DO: do i need it? (build.zig in raylib has it now, test using it!)
        if (b.lazyDependency("xcode_frameworks", .{})) |dep| {
            mod.addSystemFrameworkPath(dep.path("Frameworks"));
            mod.addSystemIncludePath(dep.path("include"));
            mod.addLibraryPath(dep.path("lib"));
        }
    }

    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
        .linux_display_backend = .Both, // select only .X11 or .Wayland if you prefer
    });

    const raylib = raylib_dep.artifact("raylib");

    mod.linkLibrary(raylib);

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}
