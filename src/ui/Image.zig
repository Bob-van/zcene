const std = @import("std");

const rlib = @import("../raylib/root.zig");

pub const InitPreset = struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
};

pub fn Image(comptime Renderer: type) type {
    const rapi = @import("../engine/api.zig").API(Renderer);
    const window = rapi.window();
    return struct {
        presets: *const [rapi.preset_size]InitPreset,
        position: rlib.math.Vector2,
        texture: rlib.r2D.Texture,

        pub const Preset = InitPreset;

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
                .position = .{
                    .x = preset.x * window.scale + @as(f32, @floatFromInt(window.left_padding)),
                    .y = preset.y * window.scale + @as(f32, @floatFromInt(window.top_padding)),
                },
                .texture = texture,
                .presets = presets,
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
        }
    };
}
