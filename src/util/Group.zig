const std = @import("std");

const GroupComponent = @import("GroupComponent.zig");

pub fn Group(comptime components: []const GroupComponent) type {
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

        pub const AccessEnum = CAccessEnum;
        pub const StorageStruct = CStorageStruct;

        pub const empty: @This() = .{
            .items = undefined,
        };

        pub fn deinit(self: *@This(), allocator: std.mem.Allocator) void {
            inline for (0..components.len) |i| {
                @field(self.items, components[i].name).deinitGeneric(allocator);
            }
        }

        pub fn get(self: *@This(), comptime element: AccessEnum) *Types[@intFromEnum(element)] {
            return &@field(self.items, components[@intFromEnum(element)].name);
        }

        pub fn draw(self: *@This()) void {
            inline for (0..components.len) |i| {
                @field(self.items, components[i].name).draw();
            }
        }
    };
}
