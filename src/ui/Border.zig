const std = @import("std");

const rlib = @import("../raylib/root.zig");

pub fn Border(comptime Renderer: type) type {
    const rapi = @import("../engine/api.zig").API(Renderer);
    const window = rapi.window();
    return struct {
        presets: *const [rapi.preset_size]Preset,
        position: rlib.math.Vector2,
        size: rlib.math.Vector2,
        thickness: f32,
        color: rlib.r2D.Color,

        pub const Preset = struct {
            x: f32,
            y: f32,
            width: f32,
            height: f32,
            thickness: f32,
        };

        pub fn init(color: rlib.r2D.Color, presets: *const [rapi.preset_size]Preset) @This() {
            const preset = presets[rapi.activePresetIndex()];
            rapi.log("Initializating UiBorder\n", .{});
            return .{
                .presets = presets,
                .position = .{
                    .x = preset.x * window.scale + @as(f32, @floatFromInt(window.left_padding)),
                    .y = preset.y * window.scale + @as(f32, @floatFromInt(window.top_padding)),
                },
                .size = .{
                    .x = preset.width * window.scale,
                    .y = preset.height * window.scale,
                },
                .thickness = preset.thickness * window.scale,
                .color = color,
            };
        }

        pub fn initAlloc(allocator: std.mem.Allocator, color: rlib.r2D.Color, preset: Preset) !*@This() {
            const ret = try allocator.create(@This());
            ret.* = init(color, preset);
            return ret;
        }

        pub fn deinitGeneric(_: *const @This(), _: std.mem.Allocator) void {}

        pub fn draw(self: *@This()) void {
            const border_width = self.thickness * 0 + self.size.x;
            const border_height = self.thickness * 0 + self.size.y;
            // top
            rlib.draw.r2D.rectangleV(
                .{
                    .x = self.position.x,
                    .y = self.position.y - self.thickness,
                },
                .{
                    .x = border_width,
                    .y = self.thickness,
                },
                self.color,
            );
            // right
            rlib.draw.r2D.rectangleV(
                .{
                    .x = self.position.x + self.size.x,
                    .y = self.position.y,
                },
                .{
                    .x = self.thickness,
                    .y = border_height,
                },
                self.color,
            );
            // bot
            rlib.draw.r2D.rectangleV(
                .{
                    .x = self.position.x,
                    .y = self.position.y + self.size.y,
                },
                .{
                    .x = border_width,
                    .y = self.thickness,
                },
                self.color,
            );
            // left
            rlib.draw.r2D.rectangleV(
                .{
                    .x = self.position.x - self.thickness,
                    .y = self.position.y,
                },
                .{
                    .x = self.thickness,
                    .y = border_height,
                },
                self.color,
            );
        }
    };
}
