const std = @import("std");

const rlib = @import("../raylib/root.zig");

pub fn Slider(comptime Renderer: type) type {
    const rapi = @import("../engine/api.zig").API(Renderer);
    const SliderHandle = @import("SliderHandle.zig").SliderHandle(Renderer);
    const window = rapi.window();
    return struct {
        presets: *const [rapi.preset_size]Preset,
        handle: *const SliderHandle,
        position: rlib.math.Vector2,
        size: rlib.math.Vector2,
        hitbox: rlib.math.Vector2,
        value: f32,
        filled_color: rlib.r2D.Color,
        empty_color: rlib.r2D.Color,

        pub const Preset = struct {
            x: f32,
            y: f32,
            width: f32,
            height: f32,
            hitbox_increase_width: f32,
            hitbox_increase_height: f32,
        };

        pub fn init(handle: *const SliderHandle, value: f32, filled_color: rlib.r2D.Color, empty_color: rlib.r2D.Color, presets: *const [rapi.preset_size]Preset) @This() {
            const preset = presets[rapi.activePresetIndex()];
            return .{
                .presets = presets,
                .handle = handle,
                .position = .{
                    .x = preset.x * window.scale + @as(f32, @floatFromInt(window.left_padding)),
                    .y = preset.y * window.scale + @as(f32, @floatFromInt(window.top_padding)),
                },
                .size = .{
                    .x = preset.width * window.scale,
                    .y = preset.height * window.scale,
                },
                .hitbox = .{
                    .x = preset.hitbox_increase_width * window.scale,
                    .y = preset.hitbox_increase_height * window.scale,
                },
                .value = value,
                .filled_color = filled_color,
                .empty_color = empty_color,
            };
        }

        pub fn initAlloc(allocator: std.mem.Allocator, handle: *const SliderHandle, value: f32, preset: Preset) !*@This() {
            const ret = try allocator.create(@This());
            ret.* = init(handle, value, preset);
            return ret;
        }

        pub fn draw(self: *const @This()) void {
            rlib.draw.r2D.rectangleV(
                self.position,
                .{
                    .x = self.size.x,
                    .y = self.size.y,
                },
                self.empty_color,
            );
            rlib.draw.r2D.rectangleV(
                self.position,
                .{
                    .x = self.value * self.size.x,
                    .y = self.size.y,
                },
                self.filled_color,
            );
            self.handle.texture.drawV(
                .{
                    .x = self.position.x + self.value * self.size.x - @as(f32, @floatFromInt(@divFloor(self.handle.texture.width, 2))),
                    .y = self.position.y + self.size.y / 2 - @as(f32, @floatFromInt(@divFloor(self.handle.texture.height, 2))),
                },
                .white,
            );
        }

        pub fn checkForMove(self: *@This(), mouse: rlib.math.Vector2) bool {
            if (rlib.collision.r2D.checkPointRec(
                mouse,
                .{
                    .x = self.position.x - self.hitbox.x,
                    .y = self.position.y - self.hitbox.y,
                    .width = self.size.x + self.hitbox.x * 2,
                    .height = self.size.y + self.hitbox.y * 2,
                },
            )) {
                const tmp = mouse.x - self.position.x;
                if (tmp < 0) {
                    self.value = 0;
                } else if (tmp > self.size.x) {
                    self.value = 1;
                } else {
                    self.value = tmp / self.size.x;
                }
                rapi.log("value is: {}%\n", .{@as(i32, @intFromFloat(self.value * 100))});
                return true;
            }
            return false;
        }

        pub fn deinitGeneric(_: @This(), _: std.mem.Allocator) void {}
    };
}
