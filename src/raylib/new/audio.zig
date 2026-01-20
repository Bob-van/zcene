const safety = @import("safety.zig");

const math = @import("math.zig");
const Matrix = math.Matrix;

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

pub const AudioCallback = ?*const fn (?*anyopaque, c_uint) callconv(.c) void;

extern fn AttachAudioMixedProcessor(processor: AudioCallback) void;
/// Attach audio stream processor to the entire audio pipeline, receives frames x 2 samples as 'float' (stereo)
pub fn attachAudioMixedProcessor(processor: AudioCallback) void {
    safety.audioInitialized();
    AttachAudioMixedProcessor(processor);
}

extern fn DetachAudioMixedProcessor(processor: AudioCallback) void;
/// Detach audio stream processor from the entire audio pipeline
pub fn detachAudioMixedProcessor(processor: AudioCallback) void {
    safety.audioInitialized();
    DetachAudioMixedProcessor(processor);
}

pub const Wave = extern struct {
    frameCount: c_uint,
    sampleRate: c_uint,
    sampleSize: c_uint,
    channels: c_uint,
    data: *anyopaque,

    pub const Error = error{InvalidWave};

    /// Checks if wave data is valid (data loaded and parameters)
    extern fn IsWaveValid(wave: Wave) bool;

    extern fn LoadWave(fileName: [*c]const u8) Wave;
    /// Load wave data from file
    pub fn initFile(fileName: [:0]const u8) Error!Wave {
        const wave = LoadWave(@ptrCast(fileName));
        if (!IsWaveValid(wave)) return Error.InvalidWave;
        safety.load();
        return wave;
    }

    extern fn LoadWaveFromMemory(fileType: [*c]const u8, fileData: [*c]const u8, dataSize: c_int) Wave;
    /// Load wave from memory buffer, fileType refers to extension: i.e. '.wav'
    pub fn initMemory(fileType: [:0]const u8, fileData: []const u8) Error!Wave {
        const wave = LoadWaveFromMemory(@ptrCast(fileType), @ptrCast(fileData), @intCast(fileData.len));
        if (!IsWaveValid(wave)) return Error.InvalidWave;
        safety.load();
        return wave;
    }

    extern fn UnloadWave(wave: Wave) void;
    /// Unload wave data
    pub fn deinit(self: Wave) void {
        safety.unload();
        UnloadWave(self);
    }

    extern fn WaveCopy(wave: Wave) Wave;
    /// Copy a wave to a new wave
    pub fn copy(wave: Wave) Wave {
        return WaveCopy(wave);
    }

    extern fn WaveCrop(wave: [*c]Wave, initFrame: c_int, finalFrame: c_int) void;
    /// Crop a wave to defined frames range
    pub fn crop(wave: *Wave, initFrame: i32, finalFrame: i32) void {
        WaveCrop(@ptrCast(wave), initFrame, finalFrame);
    }

    extern fn WaveFormat(wave: [*c]Wave, sampleRate: c_int, sampleSize: c_int, channels: c_int) void;
    /// Convert wave data to desired format
    pub fn format(wave: *Wave, sampleRate: i32, sampleSize: i32, channels: i32) void {
        WaveFormat(@ptrCast(wave), sampleRate, sampleSize, channels);
    }

    extern fn ExportWave(wave: Wave, fileName: [*c]const u8) bool;
    /// Export wave data to file, returns true on success
    pub fn toFile(wave: Wave, fileName: [:0]const u8) bool {
        return ExportWave(wave, @ptrCast(fileName));
    }

    extern fn ExportWaveAsCode(wave: Wave, fileName: [*c]const u8) bool;
    /// Export wave sample data to code (.h), returns true on success
    pub fn toCode(wave: Wave, fileName: [:0]const u8) bool {
        return ExportWaveAsCode(wave, @ptrCast(fileName));
    }

    pub const Samples = struct {
        data: []f32,

        extern fn LoadWaveSamples(wave: Wave) [*c]f32;
        /// Load samples data from wave as a 32bit float data array
        pub fn init(wave: Wave) Samples {
            safety.load();
            return .{ .data = LoadWaveSamples(wave)[0..@intCast(wave.frameCount * wave.channels)] };
        }

        extern fn UnloadWaveSamples(samples: [*c]f32) void;
        /// Unload samples data loaded with LoadWaveSamples()
        pub fn deinit(self: Samples) void {
            safety.unload();
            UnloadWaveSamples(@ptrCast(self.data));
        }
    };
};

pub const Stream = extern struct {
    buffer: *Buffer,
    processor: *Processor,
    sampleRate: c_uint,
    sampleSize: c_uint,
    channels: c_uint,

    pub const Error = error{InvalidStream};

    pub const Buffer = opaque {};
    pub const Processor = opaque {};

    /// Checks if an audio stream is valid (buffers initialized)
    extern fn IsAudioStreamValid(stream: Stream) bool;

    extern fn LoadAudioStream(sampleRate: c_uint, sampleSize: c_uint, channels: c_uint) Stream;
    /// Load audio stream (to stream raw audio pcm data)
    pub fn init(sampleRate: u32, sampleSize: u32, channels: u32) Error!Stream {
        const stream = LoadAudioStream(sampleRate, sampleSize, channels);
        if (!IsAudioStreamValid(stream)) return Error.InvalidStream;
        safety.load();
        return stream;
    }

    extern fn UnloadAudioStream(stream: Stream) void;
    /// Unload audio stream and free memory
    pub fn deinit(self: Stream) void {
        safety.unload();
        UnloadAudioStream(self);
    }

    extern fn UpdateAudioStream(stream: Stream, data: ?*const anyopaque, frameCount: c_int) void;
    /// Update audio stream buffers with data
    pub fn update(self: Stream, data: *const anyopaque, frameCount: i32) void {
        UpdateAudioStream(self, data, frameCount);
    }

    extern fn IsAudioStreamProcessed(stream: Stream) bool;
    /// Check if any audio stream buffers requires refill
    pub fn isProcessed(self: Stream) bool {
        return IsAudioStreamProcessed(self);
    }

    extern fn PlayAudioStream(stream: Stream) void;
    /// Play audio stream
    pub fn play(self: Stream) void {
        PlayAudioStream(self);
    }

    extern fn PauseAudioStream(stream: Stream) void;
    /// Pause audio stream
    pub fn pause(self: Stream) void {
        PauseAudioStream(self);
    }

    extern fn ResumeAudioStream(stream: Stream) void;
    /// Resume audio stream
    pub fn unpause(self: Stream) void {
        ResumeAudioStream(self);
    }

    extern fn IsAudioStreamPlaying(stream: Stream) bool;
    /// Check if audio stream is playing
    pub fn isPlaying(self: Stream) bool {
        return IsAudioStreamPlaying(self);
    }

    extern fn StopAudioStream(stream: Stream) void;
    /// Stop audio stream
    pub fn stop(self: Stream) void {
        StopAudioStream(self);
    }

    extern fn SetAudioStreamVolume(stream: Stream, volume: f32) void;
    /// Set volume for audio stream (1.0 is max level)
    pub fn volume(self: Stream, volume_val: f32) void {
        SetAudioStreamVolume(self, volume_val);
    }

    extern fn SetAudioStreamPitch(stream: Stream, pitch: f32) void;
    /// Set pitch for audio stream (1.0 is base level)
    pub fn pitch(self: Stream, pitch_val: f32) void {
        SetAudioStreamPitch(self, pitch_val);
    }

    extern fn SetAudioStreamPan(stream: Stream, pan: f32) void;
    /// Set pan for audio stream (0.5 is centered)
    pub fn pan(self: Stream, pan_val: f32) void {
        SetAudioStreamPan(self, pan_val);
    }

    extern fn SetAudioStreamBufferSizeDefault(size: c_int) void;
    /// Default size for new audio streams
    pub fn setBufferSizeDefault(size: i32) void {
        SetAudioStreamBufferSizeDefault(size);
    }

    extern fn SetAudioStreamCallback(stream: Stream, callback: AudioCallback) void;
    /// Audio thread callback to request new data
    pub fn setCallback(self: Stream, callback: AudioCallback) void {
        SetAudioStreamCallback(self, callback);
    }

    extern fn AttachAudioStreamProcessor(stream: Stream, processor: AudioCallback) void;
    /// Attach audio stream processor to stream, receives frames x 2 samples as 'float' (stereo)
    pub fn attachProcessor(self: Stream, processor: AudioCallback) void {
        AttachAudioStreamProcessor(self, processor);
    }

    extern fn DetachAudioStreamProcessor(stream: Stream, processor: AudioCallback) void;
    /// Detach audio stream processor from stream
    pub fn detachProcessor(self: Stream, processor: AudioCallback) void {
        DetachAudioStreamProcessor(self, processor);
    }
};

pub const Sound = extern struct {
    stream: Stream,
    frameCount: c_uint,

    pub const Error = error{InvalidSound};

    /// Checks if a sound is valid (data loaded and buffers initialized)
    extern fn IsSoundValid(sound: Sound) bool;

    extern fn LoadSound(fileName: [*c]const u8) Sound;
    /// Load sound from file
    pub fn initFile(fileName: [:0]const u8) Error!Sound {
        const sound = LoadSound(@ptrCast(fileName));
        if (!IsSoundValid(sound)) return Error.InvalidSound;
        safety.load();
        return sound;
    }

    extern fn LoadSoundFromWave(wave: Wave) Sound;
    /// Load sound from wave data
    pub fn initWave(wave: Wave) Sound {
        safety.load();
        return LoadSoundFromWave(wave);
    }

    extern fn UnloadSound(sound: Sound) void;
    /// Unload sound
    pub fn unloadSound(self: Sound) void {
        safety.unload();
        UnloadSound(self);
    }

    extern fn UpdateSound(sound: Sound, data: ?*const anyopaque, sampleCount: c_int) void;
    /// Update sound buffer with new data (data and frame count should fit in sound)
    pub fn update(sound: Sound, data: *const anyopaque, sampleCount: i32) void {
        UpdateSound(sound, data, sampleCount);
    }

    extern fn PlaySound(sound: Sound) void;
    /// Play a sound
    pub fn play(sound: Sound) void {
        PlaySound(sound);
    }

    extern fn StopSound(sound: Sound) void;
    /// Stop playing a sound
    pub fn stop(sound: Sound) void {
        StopSound(sound);
    }

    extern fn PauseSound(sound: Sound) void;
    /// Pause a sound
    pub fn pause(sound: Sound) void {
        PauseSound(sound);
    }

    extern fn ResumeSound(sound: Sound) void;
    /// Resume a paused sound
    pub fn unpause(sound: Sound) void {
        ResumeSound(sound);
    }

    extern fn IsSoundPlaying(sound: Sound) bool;
    /// Check if a sound is currently playing
    pub fn isPlaying(sound: Sound) bool {
        return IsSoundPlaying(sound);
    }

    extern fn SetSoundVolume(sound: Sound, volume: f32) void;
    /// Set volume for a sound (1.0 is max level)
    pub fn volume(sound: Sound, volume_val: f32) void {
        SetSoundVolume(sound, volume_val);
    }

    extern fn SetSoundPitch(sound: Sound, pitch: f32) void;
    /// Set pitch for a sound (1.0 is base level)
    pub fn pitch(sound: Sound, pitch_val: f32) void {
        SetSoundPitch(sound, pitch_val);
    }

    extern fn SetSoundPan(sound: Sound, pan: f32) void;
    /// Set pan for a sound (0.5 is center)
    pub fn pan(sound: Sound, pan_val: f32) void {
        SetSoundPan(sound, pan_val);
    }

    pub const Alias = struct {
        reference: Sound,

        extern fn LoadSoundAlias(source: Sound) Sound;
        /// Create a new sound that shares the same sample data as the source sound, does not own the sound data
        pub fn init(source: Sound) Alias {
            safety.load();
            return .{ .reference = LoadSoundAlias(source) };
        }

        extern fn UnloadSoundAlias(alias: Sound) void;
        /// Unload a sound alias (does not deallocate sample data)
        pub fn deinit(self: Alias) void {
            safety.unload();
            UnloadSoundAlias(self.reference);
        }

        /// Play a sound alias
        pub fn play(self: Alias) void {
            self.reference.play();
        }

        /// Stop playing a sound alias
        pub fn stop(self: Alias) void {
            self.reference.stop();
        }

        /// Pause a sound alias
        pub fn pause(self: Alias) void {
            self.reference.pause();
        }

        /// Resume a paused sound alias
        pub fn unpause(self: Alias) void {
            self.reference.unpause();
        }

        /// Check if a sound alias is currently playing
        pub fn isPlaying(self: Alias) bool {
            return self.reference.isPlaying();
        }
    };
};

pub const Music = extern struct {
    stream: Stream,
    frameCount: c_uint,
    looping: bool,
    ctxType: c_int,
    ctxData: *anyopaque,

    pub const Error = error{InvalidMusic};

    /// Checks if a music stream is valid (context and buffers initialized)
    extern fn IsMusicValid(music: Music) bool;

    extern fn LoadMusicStream(fileName: [*c]const u8) Music;
    /// Load music stream from file
    pub fn initFile(fileName: [:0]const u8) Error!Music {
        const music = LoadMusicStream(@ptrCast(fileName));
        if (!IsMusicValid(music)) return Error.InvalidMusic;
        safety.load();
        return music;
    }

    extern fn LoadMusicStreamFromMemory(fileType: [*c]const u8, data: [*c]const u8, dataSize: c_int) Music;
    /// Load music stream from data
    pub fn initMemory(fileType: [:0]const u8, data: []const u8) Error!Music {
        const music = LoadMusicStreamFromMemory(@ptrCast(fileType), @ptrCast(data), @intCast(data.len));
        if (!IsMusicValid(music)) return Error.InvalidMusic;
        safety.load();
        return music;
    }

    extern fn UnloadMusicStream(music: Music) void;
    /// Unload music stream
    pub fn deinit(self: Music) void {
        safety.unload();
        UnloadMusicStream(self);
    }

    extern fn PlayMusicStream(music: Music) void;
    /// Start music playing
    pub fn play(self: Music) void {
        PlayMusicStream(self);
    }

    extern fn IsMusicStreamPlaying(music: Music) bool;
    /// Check if music is playing
    pub fn isPlaying(self: Music) bool {
        return IsMusicStreamPlaying(self);
    }

    extern fn UpdateMusicStream(music: Music) void;
    /// Updates buffers for music streaming
    pub fn update(self: Music) void {
        UpdateMusicStream(self);
    }

    extern fn StopMusicStream(music: Music) void;
    /// Stop music playing
    pub fn stop(self: Music) void {
        StopMusicStream(self);
    }

    extern fn PauseMusicStream(music: Music) void;
    /// Pause music playing
    pub fn pause(self: Music) void {
        PauseMusicStream(self);
    }

    extern fn ResumeMusicStream(music: Music) void;
    /// Resume playing paused music
    pub fn unpause(self: Music) void {
        ResumeMusicStream(self);
    }

    extern fn SeekMusicStream(music: Music, position: f32) void;
    /// Seek music to a position (in seconds)
    pub fn seek(self: Music, position: f32) void {
        SeekMusicStream(self, position);
    }

    extern fn SetMusicVolume(music: Music, volume: f32) void;
    /// Set volume for music (1.0 is max level)
    pub fn volume(self: Music, volume_val: f32) void {
        SetMusicVolume(self, volume_val);
    }

    extern fn SetMusicPitch(music: Music, pitch: f32) void;
    /// Set pitch for a music (1.0 is base level)
    pub fn pitch(self: Music, pitch_val: f32) void {
        SetMusicPitch(self, pitch_val);
    }

    extern fn SetMusicPan(music: Music, pan: f32) void;
    /// Set pan for a music (0.5 is center)
    pub fn pan(self: Music, pan_val: f32) void {
        SetMusicPan(self, pan_val);
    }

    extern fn GetMusicTimeLength(music: Music) f32;
    /// Get music time length (in seconds)
    pub fn durationTotal(self: Music) f32 {
        return GetMusicTimeLength(self);
    }

    extern fn GetMusicTimePlayed(music: Music) f32;
    /// Get current music time played (in seconds)
    pub fn durationPlayed(self: Music) f32 {
        return GetMusicTimePlayed(self);
    }
};

pub const vr = struct {
    pub const Device = extern struct {
        hResolution: c_int,
        vResolution: c_int,
        hScreenSize: f32,
        vScreenSize: f32,
        vScreenCenter: f32,
        eyeToScreenDistance: f32,
        lensSeparationDistance: f32,
        interpupillaryDistance: f32,
        lensDistortionValues: [4]f32,
        chromaAbCorrection: [4]f32,
    };

    pub const Stereo = extern struct {
        projection: [2]Matrix,
        viewOffset: [2]Matrix,
        leftLensCenter: [2]f32,
        rightLensCenter: [2]f32,
        leftScreenCenter: [2]f32,
        rightScreenCenter: [2]f32,
        scale: [2]f32,
        scaleIn: [2]f32,

        extern fn LoadVrStereoConfig(device: vr.Device) vr.Stereo;
        /// Load VR stereo config for VR simulator device parameters
        pub fn init(device: vr.Device) vr.Stereo {
            safety.load();
            return LoadVrStereoConfig(device);
        }

        extern fn UnloadVrStereoConfig(config: vr.Stereo) void;
        /// Unload VR stereo config
        pub fn deinit(self: vr.Stereo) void {
            safety.unload();
            UnloadVrStereoConfig(self);
        }

        extern fn BeginVrStereoMode(config: vr.Stereo) void;
        /// Begin stereo rendering (requires VR simulator)
        pub fn begin(self: vr.Stereo) void {
            BeginVrStereoMode(self);
        }

        extern fn EndVrStereoMode() void;
        /// End stereo rendering (requires VR simulator)
        pub fn end(_: vr.Stereo) void {
            EndVrStereoMode();
        }
    };
};
