const std = @import("std");

const api = @import("../engine/api.zig");
const engine = @import("../engine/engine.zig");

pub const InitPreset = struct {
    x: f32,
    y: f32,
    font_size: f32,
    spacing: f32,
};

pub fn UiTextBounded(comptime Renderer: type) type {
    const API = api.API(Renderer);
    const window = API.window();
    return struct {
        presets: *const [API.preset_size]InitPreset,
        buffer: []u8,
        filled: [:0]u8,
        position: engine.Vector2,
        font_size: f32,
        spacing: f32,
        font: *const engine.Font,
        color: engine.Color,

        pub const Preset = InitPreset;

        pub fn init(buffer: [:0]u8, comptime fmt: []const u8, args: anytype, font: *const engine.Font, color: engine.Color, presets: *const [API.preset_size]Preset) !@This() {
            const preset = presets[API.activePresetIndex()];
            const text_buffer = buffer[0 .. buffer.len + 1];
            API.log("Initializating UiText\n", .{});
            return .{
                .buffer = text_buffer,
                .presets = presets,
                .filled = try std.fmt.bufPrintZ(text_buffer, fmt, args),
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

        pub fn reinit(self: *@This(), comptime fmt: []const u8, args: anytype) !void {
            self.filled = try std.fmt.bufPrintZ(self.buffer, fmt, args);
        }

        pub fn draw(self: *const @This()) void {
            engine.drawTextEx(self.font.*, self.filled, self.position, self.font_size, self.spacing, self.color);
        }

        pub fn drawWithOffset(self: *const @This(), offset_x: f32, offset_y: f32) void {
            engine.drawTextEx(self.font.*, self.filled, .{
                .x = self.position.x + offset_x,
                .y = self.position.y + offset_y,
            }, self.font_size, self.spacing, self.color);
        }
    };
}
