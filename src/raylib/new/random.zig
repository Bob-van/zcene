const safety = @import("safety.zig");

/// In my honest opinion this is a BAD game random generator!
///
/// But i will keep it for sake of compatibility.
pub const crnd = struct {
    extern fn SetRandomSeed(seed: c_uint) void;
    /// Set the seed for the random number generator
    pub fn setSeed(seed: u32) void {
        SetRandomSeed(seed);
    }

    extern fn GetRandomValue(min: c_int, max: c_int) c_int;
    /// Get a random value between min and max (both included)
    pub fn getValue(inclusive_min: i32, inclusive_max: i32) i32 {
        return GetRandomValue(inclusive_min, inclusive_max);
    }

    extern fn LoadRandomSequence(count: c_uint, min: c_int, max: c_int) [*c]c_int;
    // Load random values sequence, no values repeated
    pub fn initSequence(count: u32, inclusive_min: i32, inclusive_max: i32) []i32 {
        safety.load();
        return LoadRandomSequence(count, inclusive_min, inclusive_max)[0..@intCast(count)];
    }

    extern fn UnloadRandomSequence(sequence: [*c]c_int) void;
    /// Unload random values sequence
    pub fn deinitSequence(sequence: []i32) void {
        safety.unload();
        UnloadRandomSequence(@ptrCast(sequence));
    }
};

/// Really fast incrementing deterministic random (ITS NOT CRYPTOGRAPHICALLY SAFE).
///
/// Raylib random methods allocating for sequences is evil and this impl does not depend on libc and allows to have multiple independant instances.
///
/// Source: https://gist.github.com/tommyettinger/46a874533244883189143505d203312c
pub const zfast = struct {
    state: u32,

    /// Initialize zfast instance with seed
    pub fn init(seed: u32) @This() {
        return .{ .state = seed };
    }

    /// Get random u32, it rotates all values before repeating itself
    pub fn getRaw(self: *@This()) u32 {
        self.state +%= 0x9e3779b9;
        var t: u32 = (self.state ^ (self.state >> 16)) *% 0x21f0aaad;
        t = (t ^ (t >> 15)) *% 0x735a2d97;
        t = t ^ (t >> 15);
        return t;
    }

    /// Get a random value between inclusive_min and exclusive_max
    pub fn get(self: *@This(), inclusive_min: u32, exclusive_max: u32) u32 {
        if (safety.debug and inclusive_min >= exclusive_max) @panic("'inclusive_min' can never be same or larger than 'exclusive_max' in zfast random!");
        return inclusive_min + (self.getRaw() % (exclusive_max - inclusive_min));
    }
};
