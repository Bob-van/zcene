const std = @import("std");

const rlib = @import("../raylib/root.zig");

pub fn Rectangle(comptime Renderer: type) type {
    const rapi = @import("../engine/api.zig").API(Renderer);
    const window = rapi.window();
    return struct {
        position: rlib.math.Vector2,
        size: rlib.math.Vector2,
        color: rlib.r2D.Color,

        pub const Preset = struct {
            x: f32,
            y: f32,
            width: f32,
            height: f32,
            color: rlib.r2D.Color,
        };

        pub fn init(preset: Preset) @This() {
            rapi.log("Initializating UiRectangle\n");
            return .{
                .position = .{
                    .x = preset.x * window.scale + @as(f32, @floatFromInt(window.left_padding)),
                    .y = preset.y * window.scale + @as(f32, @floatFromInt(window.top_padding)),
                },
                .size = .{
                    .x = preset.width * window.scale,
                    .y = preset.height * window.scale,
                },
                .color = preset.color,
            };
        }

        pub fn initAlloc(allocator: std.mem.Allocator, preset: Preset) !*@This() {
            const ret = try allocator.create(@This());
            ret.* = init(preset);
            return ret;
        }

        pub fn deinitGeneral(_: *const @This(), _: std.mem.Allocator) void {}

        pub fn draw(self: *@This()) void {
            rlib.draw.r2D.rectangleV(self.position, self.size, self.color);
        }
    };
}
