/// EXPOSED ONLY BECAUSE YOU MIGHT WANT TO IMPLEMENT YOUR OWN STUFF
///
/// (for now used to expose some internal data types)
pub const BackingEngine = @import("engine/engine.zig");

pub const ScreenPreset = struct {
    width: f32,
    height: f32,
    ratio: f32,

    pub fn init(width: f32, height: f32) @This() {
        return .{
            .width = width,
            .height = height,
            .ratio = width / height,
        };
    }
};

pub const RenderableScene = struct {
    name: [:0]const u8,
    SceneTypeGenerator: fn (type) type,
    updates_per_s: comptime_int,

    pub fn init(name: [:0]const u8, SceneTypeGenerator: fn (type) type, updates_per_s: comptime_int) @This() {
        return .{
            .name = name,
            .SceneTypeGenerator = SceneTypeGenerator,
            .updates_per_s = updates_per_s,
        };
    }
};

pub fn Init(comptime presets: []const ScreenPreset, comptime scenes: []const RenderableScene, comptime SceneContext: type) type {
    return struct {
        pub const Renderer = @import("engine/renderer.zig").Renderer(presets, scenes, SceneContext);

        pub const util = struct {
            pub const GroupComponent = @import("util/GroupComponent.zig");
            pub const Group = @import("util/Group.zig").Group;
            pub const LazyGroup = @import("util/LazyGroup.zig").LazyGroup(Renderer);
        };

        pub const ui = struct {
            pub const Background = @import("ui/Background.zig").Background(Renderer);
            pub const Padding = @import("ui/Padding.zig").Padding(Renderer);
            pub const Rectangle = @import("ui/Rectangle.zig").Rectangle(Renderer);
            pub const Border = @import("ui/Border.zig").Border(Renderer);
            pub const Text = @import("ui/Text.zig").Text(Renderer);
            pub const TextBounded = @import("ui/TextBounded.zig").TextBounded(Renderer);
            pub const TextStatic = @import("ui/TextStatic.zig").TextStatic(Renderer);
            pub const Image = @import("ui/Image.zig").Image(Renderer);
            pub const Button = @import("ui/Button.zig").Button(Renderer);
            pub const SliderHandle = @import("ui/SliderHandle.zig").SliderHandle(Renderer);
            pub const Slider = @import("ui/Slider.zig").Slider(Renderer);
            pub const TextInputField = @import("ui/TextInputField.zig").TextInputField(Renderer);
            pub const TextInputFieldValue = @import("ui/TextInputFieldValue.zig").TextInputFieldValue(Renderer);
        };

        pub const audio = struct {
            pub const Music = @import("audio/Music.zig");
            pub const Sound = @import("audio/Sound.zig");
        };
    };
}

const std = @import("std");
test "raylib integration (compile errors)" {
    std.testing.refAllDeclsRecursive(@import("raylib/new/raylib.zig"));
}

test "raylib integration coverage" {
    const allocator = std.testing.allocator;

    const cwd = std.fs.cwd();

    var raylib_dir = try cwd.openDir("src/raylib/", .{});
    defer raylib_dir.close();

    var line_writer = std.io.Writer.Allocating.init(allocator);
    defer line_writer.deinit();
    const line = &line_writer.writer;

    var map: std.StringArrayHashMap(bool) = .init(allocator);
    defer map.deinit();
    defer {
        for (map.keys()) |key| {
            allocator.free(key);
        }
    }

    {
        const cdef_file = try raylib_dir.openFile("cdef.zig", .{});
        defer cdef_file.close();

        var cdef_buffer: [2048]u8 = undefined;
        var cdef_reader = std.fs.File.Reader.init(cdef_file, &cdef_buffer);
        const cdef = &cdef_reader.interface;

        while (true) {
            _ = cdef.streamDelimiter(line, '\n') catch |err| if (err == error.EndOfStream) break else return err;
            defer line_writer.clearRetainingCapacity();
            _ = try cdef.discard(.limited(1));

            var function = std.mem.trimStart(u8, line_writer.written(), &.{ ' ', '\t' });
            if (std.mem.startsWith(u8, function, "pub extern fn ")) {
                function = function[14..];
                for (function, 0..) |byte, i| {
                    if (byte == '(') {
                        function = function[0..i];
                        break;
                    }
                }
                if (!map.contains(function)) {
                    try map.put(try allocator.dupe(u8, function), false);
                }
            }
        }
    }

    var new_dir = try raylib_dir.openDir("new/", .{ .iterate = true });
    defer new_dir.close();

    var public_externs: usize = 0;
    var private_externs: usize = 0;

    var it = new_dir.iterate();
    while (try it.next()) |file| {
        if (file.kind != .file) continue;

        const found_file = try new_dir.openFile(file.name, .{});
        defer found_file.close();

        var found_buffer: [2048]u8 = undefined;
        var found_reader = std.fs.File.Reader.init(found_file, &found_buffer);
        const found = &found_reader.interface;

        while (true) {
            _ = found.streamDelimiter(line, '\n') catch |err| if (err == error.EndOfStream) break else return err;
            defer line_writer.clearRetainingCapacity();
            _ = try found.discard(.limited(1));

            var function = std.mem.trimStart(u8, line_writer.written(), &.{ ' ', '\t' });
            if (std.mem.startsWith(u8, function, "pub extern fn ")) {
                public_externs += 1;
            } else if (std.mem.startsWith(u8, function, "extern fn ")) {
                private_externs += 1;
                function = function[10..];
                for (function, 0..) |byte, i| {
                    if (byte == '(') {
                        function = function[0..i];
                        break;
                    }
                }
                if (map.getPtr(function)) |val| {
                    val.* = true;
                } else {
                    std.debug.print("Found unknown: {s}\n", .{function});
                    return error.UnknownPrivateExternFunctionFound;
                }
            }
        }
    }

    var found: usize = 0;
    var not_found: usize = 0;

    for (map.keys(), map.values()) |key, value| {
        if (value) found += 1 else {
            not_found += 1;
            std.debug.print("{s} : not-found!\n", .{key});
        }
    }

    std.debug.print("\nPublic extern functions: {}\n", .{public_externs});
    std.debug.print("Private extern functions: {}\n", .{private_externs});
    std.debug.print("Implemented: {}\n", .{found});
    std.debug.print("Missing: {}\n", .{not_found});
}
