const std = @import("std");

const rlib = @import("../raylib/root.zig");

volume: f32,
music: rlib.audio.Music,

pub fn initFromFile(fileName: [:0]const u8, volume: f32, loop: bool) !@This() {
    var ret: @This() = .{
        .volume = volume,
        .music = .initFile(fileName),
    };
    ret.looping = loop;
    ret.updateVolume();
    ret.music.play();
    return ret;
}

pub fn initFromMemory(fileType: [:0]const u8, data: []const u8, volume: f32, loop: bool) !@This() {
    var ret: @This() = .{
        .volume = volume,
        .music = try .initMemory(fileType, data),
    };
    ret.music.looping = loop;
    ret.updateVolume();
    ret.music.play();
    return ret;
}

pub fn deinit(self: *@This()) void {
    self.music.stop();
    self.music.deinit();
}

pub fn deinitGeneric(self: *@This(), _: std.mem.Allocator) void {
    self.deinit();
}

pub fn draw(self: @This()) void {
    self.music.update();
}

pub fn stopLooping(self: *@This()) void {
    self.music.looping = false;
}

pub fn isPlaying(self: @This()) bool {
    return self.music.isPlaying();
}

pub fn updateVolume(self: @This()) void {
    self.music.volume(self.volume);
}
