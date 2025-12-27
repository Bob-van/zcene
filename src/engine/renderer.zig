const std = @import("std");
const builtin = @import("builtin");
const engine = @import("engine.zig");
const api = @import("api.zig");
const ScreenPreset = @import("../root.zig").ScreenPreset;
const RenderableScene = @import("../root.zig").RenderableScene;

/// updates_per_s = 0 -> never update
pub fn Renderer(comptime presets: []const ScreenPreset, comptime scenes: []const RenderableScene, comptime SceneContext: type) type {
    var prev = std.math.floatMax(f32);
    for (presets) |screenPreset| {
        if (prev < screenPreset.ratio) @compileError("\"comptime presets: []const ScreenPreset\" need to be ordered in descending way based on \"ratio: f32\"");
        prev = screenPreset.ratio;
    }

    const update_interval_micro: [scenes.len]comptime_int = blk: {
        var intervals: [scenes.len]comptime_int = undefined;
        for (scenes, 0..) |renderableScene, i| {
            intervals[i] = if (renderableScene.updates_per_s == 0) 0 else 1000000 / renderableScene.updates_per_s;
        }
        break :blk intervals;
    };
    const does_it_ever_update: bool =
        for (scenes) |renderableScene| {
            if (renderableScene.updates_per_s != 0) break true;
        } else false;

    const does_it_ever_run_lazy: bool =
        for (scenes) |renderableScene| {
            if (renderableScene.style == .lazy) break true;
        } else false;

    return struct {
        /// Context type that functions take and gets passed to the scenes
        pub const Context = SceneContext;

        /// Enum of exposed scenes
        pub const AccessEnum = @Type(.{ .@"enum" = .{
            .tag_type = usize,
            .fields = &blk: {
                var fields: [scenes.len]std.builtin.Type.EnumField = undefined;
                for (scenes, 0..) |renderableScene, i| {
                    fields[i] = .{ .name = renderableScene.name, .value = i };
                }
                break :blk fields;
            },
            .decls = &.{},
            .is_exhaustive = true,
        } });

        /// Use API, not this, this is internal exposure that API uses!
        pub const table: api.FnTable(@This()) = .{
            .log = log,
            .window = getWindow,
            .preset_size = presets.len,
            .activePresetIndex = getCurrentPresetIndex,
            .init = init,
            .deinit = deinit,
            .initialRender = initialRender,
            .sceneUnload = publicSceneUnload,
            .render = render,
            .shouldWindowClose = wasWindowClosed,
            .requestNextScene = requestNextScene,
            .requestTermination = requestTermination,
            .requestFpsCapUpdate = requestFpsCapUpdate,
        };

        /// Exposed Renderer API (constructed like this mainly for LSP reasons)
        pub const API = api.API(@This());

        const Types = blk: {
            var types: [scenes.len]type = undefined;
            for (scenes, 0..) |renderableScene, i| {
                types[i] = renderableScene.SceneTypeGenerator(@This());
            }
            break :blk types;
        };

        const StorageUnion = blk: {
            var union_fields: [scenes.len]std.builtin.Type.UnionField = undefined;
            for (scenes, 0..) |renderableScene, i| {
                union_fields[i] = .{
                    .name = renderableScene.name,
                    .type = Types[i],
                    .alignment = @alignOf(Types[i]),
                };
            }
            break :blk @Type(.{ .@"union" = .{
                .layout = .auto,
                .tag_type = null,
                .fields = &union_fields,
                .decls = &.{},
            } });
        };

        var window_opened = false;

        var current_scene: AccessEnum = undefined;
        var next_scene: AccessEnum = undefined;

        var scene: StorageUnion = undefined;

        var current_preset_id: usize = undefined;

        var window: api.Window = undefined;

        var fps_cap: u31 = undefined;

        var last_update_micro: if (does_it_ever_update) i64 else void = undefined;
        var updates_without_change: if (does_it_ever_run_lazy) u2 else void = undefined;
        var lazy_texture: if (does_it_ever_run_lazy) engine.RenderTexture2D else void = undefined;

        fn log(comptime fmt: []const u8, args: anytype) void {
            if (builtin.mode == .Debug) {
                std.debug.print(fmt, args);
            }
        }

        fn getWindow() *const api.Window {
            return &window;
        }

        fn getCurrentPresetIndex() usize {
            return current_preset_id;
        }

        fn init(window_title: [:0]const u8, fps: ?u31) void {
            if (builtin.mode == .Debug) {
                engine.setTraceLogLevel(.warning);
            } else {
                engine.setTraceLogLevel(.err);
            }
            // open minimalized game window
            engine.initWindow(1, 1, window_title);
            // remember that window was opened
            window_opened = true;
            // get ID of monitor currently in use
            const monitor_id = engine.getCurrentMonitor();

            // get monitor scale
            const screen_width = engine.getMonitorWidth(monitor_id);
            const screen_height = engine.getMonitorHeight(monitor_id);
            log("Device screen params recieved: {d} x {d}\n", .{ screen_width, screen_height });

            const cap: u31 = fps orelse blk: {
                // compute param for removal of repeating non 0 cost calls
                const refresh_rate = engine.getMonitorRefreshRate(monitor_id);
                log("Monitor supports up to: {} FPS\n", .{refresh_rate});
                break :blk if (refresh_rate < 60) 60 else @intCast(refresh_rate);
            };
            log("Renderer targetting {} FPS\n", .{cap});

            // compute param for removal of repeating non 0 cost calls
            const window_width = @divFloor(screen_width, 4);
            // compute param for removal of repeating non 0 cost calls
            const window_height = @divFloor(screen_height, 4);

            // move window
            engine.setWindowPosition(window_width, window_height);

            const position = engine.getWindowPosition();

            if (position.x == 0 or position.y == 0) {
                // ugly hack for Wayland
                engine.closeWindow();
                engine.initWindow(window_width * 2, window_height * 2, window_title);
            } else {
                // rescale window
                engine.setWindowSize(
                    window_width * 2,
                    window_height * 2,
                );
            }

            // allow resizeability
            engine.setWindowState(.{ .window_resizable = true, .window_always_run = true });
            // set prefered gameloop speed
            requestFpsCapUpdate(cap);
            // open audio device
            engine.initAudioDevice();
        }

        fn deinit() void {
            // close audio device
            engine.closeAudioDevice();
            // close the real window
            engine.closeWindow();
            // remember that window was closed
            window_opened = false;

            if (engine.getLoaded() != 0) {
                log("Renderer was left with {} loaded assets on exit!\n", .{engine.getLoaded()});
                if (builtin.mode == .Debug) unreachable;
            }
        }

        fn wasWindowClosed() bool {
            // TO DO: make ignore ESC at specific requests
            // specidies whether was the real window closed or program thinks it was closed
            return engine.windowShouldClose() or !window_opened;
        }

        fn initialRender(context: Context, starting_scene: AccessEnum) error{SceneInitFailed}!void {
            next_scene = starting_scene;
            if (!try update(context, false)) @panic("TO DO: determine behavior on init when window is minimalized.");
        }

        fn publicSceneUnload(context: Context) void {
            if (comptime does_it_ever_run_lazy) {
                engine.unloadRenderTexture(lazy_texture);
            }
            switch (current_scene) {
                inline else => |tag| {
                    @field(scene, scenes[@intFromEnum(tag)].name).deinit(context);
                },
            }
        }

        fn sceneUnload(context: Context) void {
            switch (current_scene) {
                inline else => |tag| {
                    @field(scene, scenes[@intFromEnum(tag)].name).deinit(context);
                },
            }
        }

        fn requestNextScene(next: AccessEnum) void {
            next_scene = next;
        }

        fn requestTermination() void {
            window_opened = false;
        }

        fn requestFpsCapUpdate(new_cap: u31) void {
            fps_cap = new_cap;
            engine.setTargetFPS(@intCast(fps_cap));
        }

        fn render(context: Context) error{ SceneInitFailed, SceneUpdateFailed, SceneRenderFailed }!void {
            switch (current_scene) {
                inline else => |tag| {
                    const interval = update_interval_micro[@intFromEnum(tag)];
                    if (comptime interval != 0) {
                        const now: i64 = std.time.microTimestamp();
                        while (last_update_micro + interval < now) {
                            @field(scene, scenes[@intFromEnum(tag)].name).update(context, last_update_micro + interval) catch return error.SceneUpdateFailed;
                            last_update_micro += interval;
                        }
                    }
                },
            }
            const should_render = try update(context, true);
            // begin single frame render
            engine.beginDrawing();
            // reports end of single frame render
            defer engine.endDrawing();
            if (should_render) {
                switch (current_scene) {
                    inline else => |tag| {
                        const preset = scenes[@intFromEnum(tag)];
                        if (comptime preset.style == .lazy) {
                            if (@field(scene, preset.name).shouldRender(context)) {
                                updates_without_change = 0;
                            } else {
                                if (updates_without_change == 1) {
                                    engine.drawTextureRec(
                                        lazy_texture.texture,
                                        .init(0, 0, @floatFromInt(window.real_width), @floatFromInt(-window.real_height)),
                                        .init(0, 0),
                                        .white,
                                    );
                                    @field(scene, preset.name).final(context) catch return error.SceneRenderFailed;
                                    return;
                                }
                                updates_without_change += 1;
                            }
                        }
                        if (comptime preset.style == .lazy) engine.beginTextureMode(lazy_texture);

                        @field(scene, preset.name).render(context) catch {
                            if (comptime preset.style == .lazy) engine.endTextureMode();
                            return error.SceneRenderFailed;
                        };

                        if (comptime preset.style == .lazy) {
                            engine.endTextureMode();
                            engine.drawTextureRec(
                                lazy_texture.texture,
                                .init(0, 0, @floatFromInt(window.real_width), @floatFromInt(-window.real_height)),
                                .init(0, 0),
                                .white,
                            );
                        }
                        if (comptime preset.style == .lazy) @field(scene, preset.name).final(context) catch return error.SceneRenderFailed;
                    },
                }
            }
        }

        fn inferPreset(ratio: f32) usize {
            var new_preset_id: usize = 0;
            while (new_preset_id < presets.len and ratio < presets[new_preset_id].ratio) : (new_preset_id += 1) {}
            if (new_preset_id == 0) return 0;
            if (new_preset_id == presets.len) return new_preset_id - 1;

            const diff_large: f32 = @abs(ratio - presets[new_preset_id - 1].ratio);
            const diff_small: f32 = @abs(ratio - presets[new_preset_id].ratio);
            if (diff_large < diff_small) {
                new_preset_id -= 1;
            }
            return new_preset_id;
        }

        fn calculateInnerWindow() void {
            const f_window_width: f32 = @floatFromInt(window.real_width);
            const f_window_height: f32 = @floatFromInt(window.real_height);
            const ratio: f32 = f_window_width / f_window_height;

            log("Window size: {d} x {d}\n", .{ window.real_width, window.real_height });

            current_preset_id = inferPreset(ratio);
            const curr_preset = presets[current_preset_id];

            log("Ratio: {}, Preset: {} -> {} x {}\n", .{
                ratio,
                curr_preset.ratio,
                curr_preset.width,
                curr_preset.height,
            });

            const width_valid: bool = ratio < curr_preset.ratio;
            const single_unit: f32 = if (width_valid) f_window_width / curr_preset.width else f_window_height / curr_preset.height;
            const inner_window_width: i32 = if (width_valid) window.real_width else @intFromFloat(single_unit * curr_preset.width);
            const inner_window_height: i32 = if (width_valid) @intFromFloat(single_unit * curr_preset.height) else window.real_height;
            const width_diff: i32 = window.real_width - inner_window_width;
            const height_diff: i32 = window.real_height - inner_window_height;

            window = .{
                .real_width = window.real_width,
                .real_height = window.real_height,
                .inner_width = inner_window_width,
                .inner_height = inner_window_height,
                .scale = if (width_valid) f_window_width / curr_preset.width else f_window_height / curr_preset.height,
                .top_padding = @divFloor(height_diff, 2),
                .right_padding = @divFloor(width_diff, 2),
                .bot_padding = @divFloor(height_diff, 2) + @mod(height_diff, 2),
                .left_padding = @divFloor(width_diff, 2) + @mod(width_diff, 2),
            };

            log("{} x {} -> x{} -> {}, {}, {}, {}\n", .{
                window.inner_width,
                window.inner_height,
                window.scale,
                window.top_padding,
                window.right_padding,
                window.bot_padding,
                window.left_padding,
            });
        }

        fn update(context: Context, comptime scene_exists: bool) error{SceneInitFailed}!bool {
            const curr_width = engine.getScreenWidth();
            const curr_height = engine.getScreenHeight();
            if (curr_width <= 0 or curr_height <= 0) return false;
            if (comptime scene_exists) {
                if (curr_width == window.real_width and curr_height == window.real_height and current_scene == next_scene) return true;
            }
            if ((comptime !scene_exists) or curr_width != window.real_width or curr_height != window.real_height) {
                window.real_width = curr_width;
                window.real_height = curr_height;
                calculateInnerWindow();
                if (comptime does_it_ever_run_lazy) {
                    if (comptime scene_exists) {
                        engine.unloadRenderTexture(lazy_texture);
                    }
                    lazy_texture = engine.loadRenderTexture(window.real_width, window.real_height) catch return error.SceneInitFailed;
                }
            }
            if (comptime scene_exists) {
                sceneUnload(context);
            }
            try sceneUpdate(context);
            return true;
        }

        fn sceneUpdate(context: Context) error{SceneInitFailed}!void {
            switch (next_scene) {
                inline else => |tag| {
                    const preset = scenes[@intFromEnum(tag)];

                    // set scene union to next_scene_type.empty
                    scene = @unionInit(StorageUnion, preset.name, .empty);
                    // initialize new scene in the union (in place, so self referencial pointers stay valid)
                    @field(scene, preset.name).init(context) catch return error.SceneInitFailed;
                    if (comptime update_interval_micro[@intFromEnum(tag)] != 0) {
                        last_update_micro = std.time.microTimestamp();
                    }
                    if (comptime preset.style == .lazy) {
                        updates_without_change = 0;
                    }
                    if (next_scene == current_scene) {
                        log("Scene \"{s}\" rescaled\n", .{preset.name});
                    } else {
                        log("Scene \"{s}\" loaded\n", .{preset.name});
                    }
                },
            }
            current_scene = next_scene;
        }
    };
}
