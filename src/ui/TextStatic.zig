const std = @import("std");

const api = @import("../engine/api.zig");
const engine = @import("../engine/engine.zig");

pub const InitPreset = struct {
    x: f32,
    y: f32,
    font_size: f32,
    spacing: f32,
};

pub fn TextStatic(comptime Renderer: type) type {
    const API = api.API(Renderer);
    const window = API.window();
    return struct {
        presets: *const [API.preset_size]InitPreset,
        text: [:0]const u8,
        position: engine.Vector2,
        font_size: f32,
        spacing: f32,
        font: *const engine.Font,
        color: engine.Color,

        pub const Preset = InitPreset;

        pub fn init(text: [:0]const u8, font: *const engine.Font, color: engine.Color, presets: *const [API.preset_size]Preset) @This() {
            const preset = presets[API.activePresetIndex()];
            API.log("Initializating ui.TextStatic\n", .{});
            return .{
                .text = text,
                .presets = presets,
                .position = .{
                    .x = preset.x * window.scale + @as(f32, @floatFromInt(window.left_padding)),
                    .y = preset.y * window.scale + @as(f32, @floatFromInt(window.top_padding)),
                },
                .font_size = preset.font_size * window.scale,
                .spacing = preset.spacing * window.scale,
                .font = font,
                .color = color,
            };
        }

        pub fn deinitGeneric(_: *@This(), _: std.mem.Allocator) void {}

        pub fn draw(self: *const @This()) void {
            engine.drawTextEx(self.font.*, self.text, self.position, self.font_size, self.spacing, self.color);
        }

        pub fn drawWithOffset(self: *const @This(), offset_x: f32, offset_y: f32) void {
            engine.drawTextEx(self.font.*, self.text, .{
                .x = self.position.x + offset_x,
                .y = self.position.y + offset_y,
            }, self.font_size, self.spacing, self.color);
        }
    };
}
