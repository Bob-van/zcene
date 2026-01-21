const std = @import("std");

const rlib = @import("../raylib/root.zig");

pub fn Background(comptime Renderer: type) type {
    const rapi = @import("../engine/api.zig").API(Renderer);
    return struct {
        color: rlib.r2D.Color,

        pub fn init(color: rlib.r2D.Color) @This() {
            rapi.log("Initializating UiBackground\n", .{});
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
            rlib.draw.clear(self.color);
        }
    };
}
