const safety = @import("safety.zig");

extern fn InitAudioDevice() void;
/// Initialize audio device and context
pub fn init() void {
    safety.initAudioDevice();
    InitAudioDevice();
}

extern fn CloseAudioDevice() void;
/// Close the audio device and context
pub fn deinit() void {
    safety.closeAudioDevice();
    CloseAudioDevice();
}

extern fn IsAudioDeviceReady() bool;
/// Check if audio device has been initialized successfully
pub fn isReady() bool {
    safety.audioInitialized();
    return IsAudioDeviceReady();
}

extern fn SetMasterVolume(volume: f32) void;
/// Set master volume (listener)
pub fn setMasterVolume(volume: f32) void {
    safety.audioInitialized();
    SetMasterVolume(volume);
}

extern fn GetMasterVolume() f32;
/// Get master volume (listener)
pub fn getMasterVolume() f32 {
    safety.audioInitialized();
    return GetMasterVolume();
}
