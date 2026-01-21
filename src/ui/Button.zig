const std = @import("std");

const rlib = @import("../raylib/root.zig");

pub fn Button(comptime Renderer: type) type {
    const rapi = @import("../engine/api.zig").API(Renderer);
    const window = rapi.window();
    return struct {
        presets: *const [rapi.preset_size]Preset,
        position: rlib.math.Vector2,
        texture: rlib.r2D.Texture,
        hovered: bool,

        pub const Preset = struct {
            x: f32,
            y: f32,
            width: f32,
            height: f32,
        };

        const hover_color: rlib.r2D.Color = .init(200, 200, 200, 255);

        pub fn init(image: []const u8, presets: *const [rapi.preset_size]Preset) !@This() {
            const preset = presets[rapi.activePresetIndex()];
            var rlib_image: rlib.r2D.Image = try .initMemory(".png", image);
            defer rlib_image.deinit();
            rapi.log("Image loaded successfully: {d}x{d}\n", .{ rlib_image.width, rlib_image.height });
            rlib_image.resizeNN(
                @intFromFloat(preset.width * window.scale),
                @intFromFloat(preset.height * window.scale),
            );
            rapi.log("Image resized to: {d}x{d}\n", .{ rlib_image.width, rlib_image.height });
            const texture: rlib.r2D.Texture = try .initImage(rlib_image);
            rapi.log("Texture created from image\n", .{});
            return .{
                .presets = presets,
                .position = .{
                    .x = preset.x * window.scale + @as(f32, @floatFromInt(window.left_padding)),
                    .y = preset.y * window.scale + @as(f32, @floatFromInt(window.top_padding)),
                },
                .texture = texture,
                .hovered = false,
            };
        }

        pub fn initAlloc(allocator: std.mem.Allocator, image: []const u8, preset: Preset) !*@This() {
            const ret = try allocator.create(@This());
            ret.* = try init(image, preset);
            return ret;
        }

        pub fn deinit(self: *@This()) void {
            self.texture.deinit();
            rapi.log("Texture unloaded\n", .{});
        }

        pub fn deinitGeneric(self: *@This(), _: std.mem.Allocator) void {
            self.deinit();
        }

        pub fn draw(self: *const @This()) void {
            self.texture.drawV(self.position, .white);
            if (self.hovered) {
                const blend: rlib.r2D.BlendMode = .alpha;
                blend.begin();
                self.texture.drawV(self.position, hover_color);
                blend.end();
            }
        }

        pub fn drawEx(self: *const @This(), position: rlib.math.Vector2) void {
            self.texture.drawV(self.position, .white);
            if (self.hovered) {
                const blend: rlib.r2D.BlendMode = .alpha;
                blend.begin();
                self.texture.drawV(position, hover_color);
                blend.end();
            }
        }

        pub fn isPressed(self: *const @This(), mouse: rlib.math.Vector2) bool {
            return rlib.r2D.collision.checkPointRec(
                mouse,
                .{
                    .x = self.position.x,
                    .y = self.position.y,
                    .width = @floatFromInt(self.texture.width),
                    .height = @floatFromInt(self.texture.height),
                },
            );
        }

        pub fn checkForHover(self: *@This(), mouse: rlib.math.Vector2) bool {
            const tmp = self.hovered;
            self.hovered = if (rlib.r2D.collision.checkPointRec(
                mouse,
                .{
                    .x = self.position.x,
                    .y = self.position.y,
                    .width = @floatFromInt(self.texture.width),
                    .height = @floatFromInt(self.texture.height),
                },
            ))
                true
            else
                false;
            return tmp != self.hovered;
        }
    };
}
