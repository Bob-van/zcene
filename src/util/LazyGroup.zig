const std = @import("std");

const api = @import("../engine/api.zig");
const engine = @import("../engine/engine.zig");
const GroupComponent = @import("GroupComponent.zig");

pub fn LazyGroup(comptime Renderer: type) fn (comptime components: []const GroupComponent) type {
    const API = api.API(Renderer);
    const window = API.window();
    return struct {
        pub fn LazyGroup(comptime components: []const GroupComponent) type {
            comptime var Types: [components.len]type = undefined;
            comptime var enum_fields: [components.len]std.builtin.Type.EnumField = undefined;
            comptime var struct_fields: [components.len]std.builtin.Type.StructField = undefined;
            for (components, 0..) |group_component, i| {
                Types[i] = group_component.ComponentType;
                enum_fields[i] = .{
                    .name = group_component.name,
                    .value = i,
                };
                struct_fields[i] = .{
                    .name = group_component.name,
                    .type = group_component.ComponentType,
                    .default_value_ptr = null,
                    .is_comptime = false,
                    .alignment = @alignOf(group_component.ComponentType),
                };
            }
            const CAccessEnum = @Type(.{ .@"enum" = .{
                .tag_type = usize,
                .fields = &enum_fields,
                .decls = &.{},
                .is_exhaustive = true,
            } });

            const CStorageStruct = @Type(.{ .@"struct" = .{
                .layout = .auto,
                .backing_integer = null,
                .fields = &struct_fields,
                .decls = &.{},
                .is_tuple = false,
            } });
            return struct {
                items: StorageStruct,
                lazy_texture: engine.RenderTexture2D,

                pub const AccessEnum = CAccessEnum;
                pub const StorageStruct = CStorageStruct;

                pub const empty: @This() = .{
                    .items = undefined,
                    .lazy_texture = undefined,
                };

                pub fn init(self: *@This()) !void {
                    self.lazy_texture = try engine.loadRenderTexture(window.real_width, window.real_height);
                }

                /// deinitializes texture, but not the components
                pub fn deinitTexture(self: *@This()) void {
                    engine.unloadRenderTexture(self.lazy_texture);
                }

                /// deinitializes texture and internal components
                pub fn deinit(self: *@This(), allocator: std.mem.Allocator) void {
                    self.deinitTexture();
                    inline for (0..components.len) |i| {
                        @field(self.items, components[i].name).deinitGeneric(allocator);
                    }
                }

                pub fn get(self: *@This(), comptime element: AccessEnum) *Types[@intFromEnum(element)] {
                    return &@field(self.items, components[@intFromEnum(element)].name);
                }

                pub fn draw(self: *@This(), changed: bool) void {
                    if (changed) {
                        API.log("Lazy group rerendered content!\n", .{});
                        engine.beginTextureMode(self.lazy_texture);
                        defer engine.endTextureMode();
                        inline for (0..components.len) |i| {
                            @field(self.items, components[i].name).draw();
                        }
                    }
                    engine.drawTextureRec(
                        self.lazy_texture.texture,
                        .init(0, 0, @floatFromInt(window.real_width), @floatFromInt(-window.real_height)),
                        .init(0, 0),
                        .white,
                    );
                }
            };
        }
    }.LazyGroup;
}
