const safety = @import("safety.zig");

extern fn BeginDrawing() void;
/// Setup canvas (framebuffer) to start drawing
pub fn beginDrawing() void {
    safety.beginDrawing();
    BeginDrawing();
}

extern fn EndDrawing() void;
/// End canvas drawing and swap buffers (double buffering)
pub fn endDrawing() void {
    safety.endDrawing();
    EndDrawing();
}
