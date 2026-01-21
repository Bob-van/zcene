const safety = @import("safety.zig");

const math = @import("math.zig");
const Vector2 = math.Vector2;

const r2D = @import("2D.zig");
const Image = r2D.Image;

const io = @import("io.zig");
const keyboard = io.keyboard;

pub const Flags = packed struct {
    __reserved1: bool = false,
    fullscreen_mode: bool = false,
    window_resizable: bool = false,
    window_undecorated: bool = false,
    window_transparent: bool = false,
    msaa_4x_hint: bool = false,
    vsync_hint: bool = false,
    window_hidden: bool = false,
    window_always_run: bool = false,
    window_minimized: bool = false,
    window_maximized: bool = false,
    window_unfocused: bool = false,
    window_topmost: bool = false,
    window_highdpi: bool = false,
    window_mouse_passthrough: bool = false,
    borderless_windowed_mode: bool = false,
    interlaced_hint: bool = false,
    __reserved2: bool = false,
    __reserved3: bool = false,
    __reserved4: bool = false,
    __reserved5: bool = false,
    __reserved6: bool = false,
    __reserved7: bool = false,
    __reserved8: bool = false,
    __reserved9: bool = false,
    __reserved10: bool = false,
    __reserved11: bool = false,
    __reserved12: bool = false,
    __reserved13: bool = false,
    __reserved14: bool = false,
    __reserved15: bool = false,
    __reserved16: bool = false,
};

extern fn SetConfigFlags(flags: c_uint) void;
extern fn InitWindow(width: c_int, height: c_int, title: [*c]const u8) void;
/// Initialize window and OpenGL context
pub fn init(width: i32, height: i32, title: [:0]const u8, flags: Flags) void {
    safety.initWindow();
    SetConfigFlags(@bitCast(flags));
    InitWindow(width, height, @ptrCast(title));
}

extern fn CloseWindow() void;
/// Close window and unload OpenGL context
pub fn deinit() void {
    safety.closeWindow();
    CloseWindow();
}

extern fn WindowShouldClose() bool;
/// Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)
pub fn shouldClose() bool {
    return WindowShouldClose();
}

extern fn IsWindowReady() bool;
/// Check if window has been initialized successfully
pub fn isReady() bool {
    return IsWindowReady();
}

extern fn IsWindowFullscreen() bool;
/// Check if window is currently fullscreen
pub fn isFullscreen() bool {
    return IsWindowFullscreen();
}

extern fn IsWindowHidden() bool;
/// Check if window is currently hidden
pub fn isHidden() bool {
    return IsWindowHidden();
}

extern fn IsWindowMinimized() bool;
/// Check if window is currently minimized
pub fn isMinimized() bool {
    return IsWindowMinimized();
}

extern fn IsWindowMaximized() bool;
/// Check if window is currently maximized
pub fn isMaximized() bool {
    return IsWindowMaximized();
}

extern fn IsWindowFocused() bool;
/// Check if window is currently focused
pub fn isFocused() bool {
    return IsWindowFocused();
}

extern fn IsWindowResized() bool;
/// Check if window has been resized last frame
pub fn isResized() bool {
    return IsWindowResized();
}

extern fn IsWindowState(flag: c_uint) bool;
/// Check if one specific window flag is enabled
pub fn isState(flag: Flags) bool {
    return IsWindowState(@bitCast(flag));
}

extern fn SetWindowState(flags: c_uint) void;
/// Set window configuration state using flags
pub fn setState(flags: Flags) void {
    SetWindowState(@bitCast(flags));
}

extern fn ClearWindowState(flags: c_uint) void;
/// Clear window configuration state flags
pub fn clearState(flags: Flags) void {
    ClearWindowState(@bitCast(flags));
}

extern fn ToggleFullscreen() void;
/// Toggle window state: fullscreen/windowed, resizes monitor to match window resolution
pub fn toggleFullscreen() void {
    ToggleFullscreen();
}

extern fn ToggleBorderlessWindowed() void;
/// Toggle window state: borderless windowed, resizes window to match monitor resolution
pub fn toggleBorderless() void {
    ToggleBorderlessWindowed();
}

extern fn MaximizeWindow() void;
/// Set window state: maximized, if resizable
pub fn maximize() void {
    MaximizeWindow();
}

extern fn MinimizeWindow() void;
/// Set window state: minimized, if resizable
pub fn minimize() void {
    MinimizeWindow();
}

extern fn RestoreWindow() void;
/// Restore window from being minimized/maximized
pub fn restore() void {
    RestoreWindow();
}

/// Set icon for window (single image, RGBA 32bit)
pub fn setIcon(image: Image) void {
    image.setAsWindowIcon();
}

extern fn SetWindowIcons(images: [*c]Image, count: c_int) void;
/// Set icon for window (multiple images, RGBA 32bit, only PLATFORM_DESKTOP)
pub fn setIcons(images: []Image) void {
    SetWindowIcons(@ptrCast(images), @intCast(images.len));
}

extern fn SetWindowTitle(title: [*c]const u8) void;
/// Set title for window
pub fn setTitle(title: [:0]const u8) void {
    SetWindowTitle(@ptrCast(title));
}

extern fn SetWindowPosition(x: c_int, y: c_int) void;
/// Set window position on screen
pub fn setPosition(x: i32, y: i32) void {
    SetWindowPosition(x, y);
}

extern fn SetWindowMonitor(monitor: c_int) void;
/// Set monitor for the current window
pub fn setMonitor(monitor: i32) void {
    SetWindowMonitor(monitor);
}

extern fn SetWindowMinSize(width: c_int, height: c_int) void;
/// Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
pub fn setMinSize(width: i32, height: i32) void {
    SetWindowMinSize(width, height);
}

extern fn SetWindowMaxSize(width: c_int, height: c_int) void;
/// Set window maximum dimensions (for FLAG_WINDOW_RESIZABLE)
pub fn setMaxSize(width: i32, height: i32) void {
    SetWindowMaxSize(width, height);
}

extern fn SetWindowSize(width: c_int, height: c_int) void;
/// Set window dimensions
pub fn setSize(width: i32, height: i32) void {
    SetWindowSize(width, height);
}

extern fn SetWindowOpacity(opacity: f32) void;
/// Set window opacity [0.0f..1.0f]
pub fn setOpacity(opacity: f32) void {
    SetWindowOpacity(opacity);
}

extern fn SetWindowFocused() void;
/// Set window focused
pub fn setFocused() void {
    SetWindowFocused();
}

extern fn GetWindowHandle() ?*anyopaque;
/// Get native window handle
pub fn getHandle() *anyopaque {
    return GetWindowHandle().?;
}

extern fn GetWindowPosition() Vector2;
/// Get window position XY on monitor
pub fn getPosition() Vector2 {
    return GetWindowPosition();
}

extern fn GetWindowScaleDPI() Vector2;
/// Get window scale DPI factor
pub fn getScaleDPI() Vector2 {
    return GetWindowScaleDPI();
}

extern fn GetRenderWidth() c_int;
/// Get current render width (it considers HiDPI)
pub fn getRenderWidth() i32 {
    return GetRenderWidth();
}

extern fn GetRenderHeight() c_int;
/// Get current render height (it considers HiDPI)
pub fn getRenderHeight() i32 {
    return GetRenderHeight();
}

/// Set a custom key to exit program (default is ESC)
pub fn setExitKey(key: keyboard.Key) void {
    keyboard.setExitKey(key);
}

extern fn TakeScreenshot(fileName: [*c]const u8) void;
/// Takes a screenshot of current screen (filename extension defines format)
pub fn takeScreenshot(fileName: [:0]const u8) void {
    TakeScreenshot(@ptrCast(fileName));
}
