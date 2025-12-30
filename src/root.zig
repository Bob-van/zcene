/// EXPOSED ONLY BECAUSE YOU MIGHT WANT TO IMPLEMENT YOUR OWN STUFF
///
/// (for now used to expose some internal data types)
pub const BackingEngine = @import("engine/engine.zig");

pub const ScreenPreset = struct {
    width: f32,
    height: f32,
    ratio: f32,

    pub fn init(width: f32, height: f32) @This() {
        return .{
            .width = width,
            .height = height,
            .ratio = width / height,
        };
    }
};

pub const RenderableScene = struct {
    name: [:0]const u8,
    SceneTypeGenerator: fn (type) type,
    updates_per_s: comptime_int,

    pub fn init(name: [:0]const u8, SceneTypeGenerator: fn (type) type, updates_per_s: comptime_int) @This() {
        return .{
            .name = name,
            .SceneTypeGenerator = SceneTypeGenerator,
            .updates_per_s = updates_per_s,
        };
    }
};

pub fn Init(comptime presets: []const ScreenPreset, comptime scenes: []const RenderableScene, comptime SceneContext: type) type {
    return struct {
        pub const Renderer = @import("engine/renderer.zig").Renderer(presets, scenes, SceneContext);

        pub const util = struct {
            pub const GroupComponent = @import("util/GroupComponent.zig");
            pub const Group = @import("util/Group.zig").Group;
            pub const LazyGroup = @import("util/LazyGroup.zig").LazyGroup(Renderer);
        };

        pub const ui = struct {
            pub const Background = @import("ui/Background.zig").Background(Renderer);
            pub const Padding = @import("ui/Padding.zig").Padding(Renderer);
            pub const Rectangle = @import("ui/Rectangle.zig").Rectangle(Renderer);
            pub const Border = @import("ui/Border.zig").Border(Renderer);
            pub const Text = @import("ui/Text.zig").Text(Renderer);
            pub const TextBounded = @import("ui/TextBounded.zig").TextBounded(Renderer);
            pub const Image = @import("ui/Image.zig").Image(Renderer);
            pub const Button = @import("ui/Button.zig").Button(Renderer);
            pub const SliderHandle = @import("ui/SliderHandle.zig").SliderHandle(Renderer);
            pub const Slider = @import("ui/Slider.zig").Slider(Renderer);
            pub const TextInputField = @import("ui/TextInputField.zig").TextInputField(Renderer);
            pub const TextValue = @import("ui/TextValue.zig").TextValue(Renderer);
        };

        pub const audio = struct {
            pub const Music = @import("audio/Music.zig");
            pub const Sound = @import("audio/Sound.zig");
        };
    };
}
