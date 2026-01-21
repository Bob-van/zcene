const std = @import("std");

const rlib = @import("../raylib/root.zig");

/// Adds colored blocks to the edges of screen (when window size is not exact fit)
pub fn Padding(comptime Renderer: type) type {
    const rapi = @import("../engine/api.zig").API(Renderer);
    const window = rapi.window();
    return struct {
        color: rlib.r2D.Color,

        pub fn init(color: rlib.r2D.Color) @This() {
            return .{
                .color = color,
            };
        }

        pub fn initAlloc(allocator: std.mem.Allocator, color: rlib.r2D.Color) !*@This() {
            const ret = try allocator.create(@This());
            ret.* = init(color);
            return ret;
        }

        pub fn deinitGeneric(_: @This(), _: std.mem.Allocator) void {}

        pub fn draw(self: @This()) void {
            // top
            rlib.draw.r2D.rectangle(0, 0, window.real_width, window.top_padding, self.color);
            // right
            rlib.draw.r2D.rectangle(window.inner_width + window.left_padding, 0, window.right_padding, window.real_height, self.color);
            // bot
            rlib.draw.r2D.rectangle(0, window.inner_height + window.top_padding, window.real_width, window.bot_padding, self.color);
            // left
            rlib.draw.r2D.rectangle(0, 0, window.left_padding, window.real_width, self.color);
        }
    };
}
