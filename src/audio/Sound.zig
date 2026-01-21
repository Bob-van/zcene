const std = @import("std");

const rlib = @import("root").rlib;

volume: f32,
music: rlib.audio.Sound,

comptime {
    // When analized (aka. imported by other code and used) it trips the compiler!
    @compileError("TO DO!");
}
