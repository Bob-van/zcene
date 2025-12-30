name: [:0]const u8,
ComponentType: type,

pub fn init(name: [:0]const u8, ComponentType: type) @This() {
    return .{
        .name = name,
        .ComponentType = ComponentType,
    };
}
