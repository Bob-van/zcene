const builtin = @import("builtin");

pub const debug = builtin.mode == .Debug or builtin.mode == .ReleaseSafe;

pub fn DebugType(T: type) type {
    return if (debug) T else @compileError("This variable only exists in Debug and ReleaseSafe builds!");
}

pub var window: DebugType(bool) = false;

pub fn initWindow() void {
    if (debug) {
        if (window) @panic("Window already initialized!");
        window = true;
    }
}

pub fn closeWindow() void {
    if (debug) {
        if (!window) @panic("Window already closed!");
        window = false;
    }
}

pub fn windowInitialized() void {
    if (debug and !window) @panic("Window must be initialized!");
}

pub var audio_device: DebugType(bool) = false;

pub fn initAudioDevice() void {
    if (debug) {
        if (audio_device) @panic("Audio device already initialized!");
        audio_device = true;
    }
}

pub fn closeAudioDevice() void {
    if (debug) {
        if (!audio_device) @panic("Audio device already closed!");
        audio_device = false;
    }
}

pub fn audioInitialized() void {
    if (debug and !audio_device) @panic("Audio device must be initialized!");
}

pub var drawing: DebugType(bool) = false;

pub fn beginDrawing() void {
    if (debug) {
        if (drawing) @panic("Frame drawing already begun!");
        drawing = true;
    }
}

pub fn endDrawing() void {
    if (debug) {
        if (!drawing) @panic("Frame drawing already ended!");
        drawing = false;
    }
}

pub fn drawingBegun() void {
    if (debug and !drawing) @panic("Frame drawing must begin!");
}

pub var loaded: DebugType(usize) = 0;

pub fn load() void {
    if (debug) loaded += 1; // checked overflow
}

pub fn unload() void {
    if (debug) loaded -= 1; // checked underflow
}
