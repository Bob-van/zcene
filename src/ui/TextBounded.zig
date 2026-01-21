const std = @import("std");

const rlib = @import("../raylib/root.zig");

pub const InitPreset = struct {
    x: f32,
    y: f32,
    font_size: f32,
    spacing: f32,
};

pub fn TextBounded(comptime Renderer: type) type {
    const rapi = @import("../engine/api.zig").API(Renderer);
    const window = rapi.window();
    return struct {
        presets: *const [rapi.preset_size]InitPreset,
        buffer: []u8,
        filled: [:0]u8,
        position: rlib.math.Vector2,
        font_size: f32,
        spacing: f32,
        font: *const rlib.text.Font,
        color: rlib.r2D.Color,

        pub const Preset = InitPreset;

        pub fn init(buffer: [:0]u8, comptime fmt: []const u8, args: anytype, font: *const rlib.text.Font, color: rlib.r2D.Color, presets: *const [rapi.preset_size]Preset) !@This() {
            const preset = presets[rapi.activePresetIndex()];
            const text_buffer = buffer[0 .. buffer.len + 1];
            rapi.log("Initializating UiText\n", .{});
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
            self.font.drawTextEx(self.filled, self.position, self.font_size, self.spacing, self.color);
        }

        pub fn drawWithOffset(self: *const @This(), offset_x: f32, offset_y: f32) void {
            self.font.drawTextEx(
                self.filled,
                .{
                    .x = self.position.x + offset_x,
                    .y = self.position.y + offset_y,
                },
                self.font_size,
                self.spacing,
                self.color,
            );
        }
    };
}
