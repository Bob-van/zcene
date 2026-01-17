const std = @import("std");

const safety = @import("safety.zig");

const math = @import("math.zig");
const Vector2 = math.Vector2;

extern fn GetMonitorCount() c_int;
/// Get number of connected monitors
pub fn count() i32 {
    return GetMonitorCount();
}

extern fn GetCurrentMonitor() c_int;
/// Get current monitor where window is placed
pub fn current() i32 {
    return GetCurrentMonitor();
}

extern fn GetMonitorPosition(monitor: c_int) Vector2;
/// Get specified monitor position
pub fn position(monitor: i32) Vector2 {
    return GetMonitorPosition(monitor);
}

extern fn GetMonitorWidth(monitor: c_int) c_int;
/// Get specified monitor width (current video mode used by monitor)
pub fn width(monitor: i32) i32 {
    return GetMonitorWidth(monitor);
}

extern fn GetMonitorHeight(monitor: c_int) c_int;
/// Get specified monitor height (current video mode used by monitor)
pub fn height(monitor: i32) i32 {
    return GetMonitorHeight(monitor);
}

extern fn GetMonitorPhysicalWidth(monitor: c_int) c_int;
/// Get specified monitor physical width in millimetres
pub fn physicalWidth(monitor: i32) i32 {
    return GetMonitorPhysicalWidth(monitor);
}

extern fn GetMonitorPhysicalHeight(monitor: c_int) c_int;
/// Get specified monitor physical height in millimetres
pub fn physicalHeight(monitor: i32) i32 {
    return GetMonitorPhysicalHeight(monitor);
}

extern fn GetMonitorRefreshRate(monitor: c_int) c_int;
/// Get specified monitor refresh rate
pub fn refreshRate(monitor: i32) i32 {
    return GetMonitorRefreshRate(monitor);
}

extern fn GetMonitorName(monitor: c_int) [*c]const u8;
/// Get the human-readable, UTF-8 encoded name of the specified monitor
pub fn name(monitor: i32) [:0]const u8 {
    return std.mem.span(GetMonitorName(monitor));
}

extern fn GetScreenWidth() c_int;
/// Get current screen width
pub fn screenWidth() i32 {
    return GetScreenWidth();
}

extern fn GetScreenHeight() c_int;
/// Get current screen height
pub fn screenHeight() i32 {
    return GetScreenHeight();
}
