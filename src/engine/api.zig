pub const Window = struct {
    real_width: i32,
    real_height: i32,
    inner_width: i32,
    inner_height: i32,
    scale: f32,
    top_padding: i32,
    right_padding: i32,
    bot_padding: i32,
    left_padding: i32,
};

pub fn FnTable(Renderer: type) type {
    return struct {
        log: fn (comptime []const u8, anytype) void,
        window: fn () *const Window,
        preset_size: usize,
        activePresetIndex: fn () usize,
        init: fn (Renderer.Context, Renderer.AccessEnum) error{SceneInitFailed}!void,
        deinit: fn (Renderer.Context) void,
        render: fn (Renderer.Context) error{ SceneInitFailed, SceneUpdateFailed, SceneRenderFailed }!void,
        requestNextScene: fn (Renderer.AccessEnum) void,
        requestTermination: fn () void,
        terminationRequested: fn () bool,
    };
}

/// Renderer concrete public API.
///
/// (mostly here cuz LSP sucks for duck typing)
pub fn API(Renderer: type) type {
    return struct {
        /// Internal fn table of Renderer implementation
        pub const table: FnTable(Renderer) = Renderer.table;
        /// Log function, guess what it does ...
        ///
        /// IMPORTANT: logs only in .Debug builds!
        pub fn log(comptime fmt: []const u8, args: anytype) void {
            table.log(fmt, args);
        }
        /// Details about current renderer setup.
        pub fn window() *const Window {
            return table.window();
        }
        /// Screen presets length. (its guaranteed static)
        pub const preset_size: usize = table.preset_size;
        /// Get index of preset currently in use by renderer.
        pub fn activePresetIndex() usize {
            return table.activePresetIndex();
        }
        /// Initializes window using provided title and fps cap.
        ///
        /// (null means use monitor refresh rate)
        ///
        /// IMPORTANT: requires deinit() to be called before exiting!
        pub fn init(ctx: Renderer.Context, scene: Renderer.AccessEnum) error{SceneInitFailed}!void {
            return table.init(ctx, scene);
        }
        /// Deinitializes window and all internal resources.
        ///
        /// IMPORTANT: all other render functions stop working afterwards!
        pub fn deinit(ctx: Renderer.Context) void {
            table.deinit(ctx);
        }
        /// Renders scene, if new scene is requested loads it first.
        ///
        /// Calls update method as perfectly as it can based on "updates_per_s" regardless of current FPS.
        ///
        /// When new scene is loaded, it resets the update method "sleep" timer, so its not called immediately.
        ///
        /// IMPORTANT: expects loaded scene inside renderer! (see initialRender() for loading it)
        pub fn render(ctx: Renderer.Context) error{ SceneInitFailed, SceneUpdateFailed, SceneRenderFailed }!void {
            return table.render(ctx);
        }

        /// Requests new scene to be loaded on next render() call.
        ///
        /// (safely overwrites previous requests, if they happen before render() call)
        pub fn requestNextScene(scene: Renderer.AccessEnum) void {
            table.requestNextScene(scene);
        }
        /// Requests window termination programatically so shouldWindowClose() returns true.
        pub fn requestTermination() void {
            table.requestTermination();
        }
        /// Returns whether window termination was requested.
        ///
        /// (escape key pressed or window close icon clicked)
        pub fn terminationRequested() bool {
            return table.terminationRequested();
        }
    };
}
