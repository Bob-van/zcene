const safety = @import("safety.zig");

extern fn BeginDrawing() void;
/// Setup canvas (framebuffer) to start drawing
pub fn begin() void {
    safety.beginDrawing();
    BeginDrawing();
}

extern fn EndDrawing() void;
/// End canvas drawing and swap buffers (double buffering)
pub fn end() void {
    safety.endDrawing();
    EndDrawing();
}

/// u31 chosen to safely cast to/from i32 which the C implementation uses
///
/// values < 1 have all same meaning, no reason to allow them all
pub const TargetFps = enum(u31) {
    unlimited = 0,
    _,

    /// WARNING: 0 is reserved for unlimited!
    ///
    /// (construction wont fail, however be avare of intent of this value)
    pub fn init(fps: u31) @This() {
        return @enumFromInt(fps);
    }
};

var target: TargetFps = .unlimited;

/// Get target FPS (maximum)
pub fn getTargetFPS() TargetFps {
    return target;
}

extern fn SetTargetFPS(fps: c_int) void;
/// Set target FPS (maximum)
pub fn setTargetFPS(fps: TargetFps) void {
    target = fps;
    SetTargetFPS(@intFromEnum(fps));
}

extern fn GetFrameTime() f32;
/// Get time in seconds for last frame drawn (delta time)
pub fn getDeltaTime() f32 {
    return GetFrameTime();
}

extern fn GetTime() f64;
/// Get elapsed time in seconds since InitWindow()
pub fn getTime() f64 {
    return GetTime();
}

extern fn GetFPS() c_int;
/// Get current FPS
pub fn getFPS() i32 {
    return GetFPS();
}

/// Custom frame control functions (be carefull might break the Zig side safety stuff)
///
/// NOTE: Those functions are intended for advanced users that want full control over the frame processing
///
/// By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
pub const lowlevel = struct {
    extern fn SwapScreenBuffer() void;
    /// Swap back buffer with front buffer (screen drawing)
    pub fn swapScreenBuffer() void {
        SwapScreenBuffer();
    }

    extern fn PollInputEvents() void;
    /// Register all input events
    pub fn pollInputEvents() void {
        PollInputEvents();
    }

    extern fn WaitTime(seconds: f64) void;
    /// Wait for some time (halt program execution)
    pub fn waitTime(seconds: f64) void {
        WaitTime(seconds);
    }
};
