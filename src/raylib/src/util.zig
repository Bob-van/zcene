extern fn TraceLog(logLevel: c_int, text: [*c]const u8, ...) void;
extern fn SetTraceLogLevel(logLevel: c_int) void;

pub const mem = struct {
    extern fn MemAlloc(size: c_uint) ?*anyopaque;
    extern fn MemRealloc(ptr: ?*anyopaque, size: c_uint) ?*anyopaque;
    extern fn MemFree(ptr: ?*anyopaque) void;
};

pub const callback = struct {
    pub const struct___va_list_tag_1 = extern struct {
        gp_offset: c_uint = @import("std").mem.zeroes(c_uint),
        fp_offset: c_uint = @import("std").mem.zeroes(c_uint),
        overflow_arg_area: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
        reg_save_area: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    };
    pub const TraceLogCallback = ?*const fn (c_int, [*c]const u8, [*c]struct___va_list_tag_1) callconv(.c) void;
    pub const LoadFileDataCallback = ?*const fn ([*c]const u8, [*c]c_int) callconv(.c) [*c]u8;
    pub const SaveFileDataCallback = ?*const fn ([*c]const u8, ?*anyopaque, c_int) callconv(.c) bool;
    pub const LoadFileTextCallback = ?*const fn ([*c]const u8) callconv(.c) [*c]u8;
    pub const SaveFileTextCallback = ?*const fn ([*c]const u8, [*c]const u8) callconv(.c) bool;

    extern fn SetTraceLogCallback(callback: TraceLogCallback) void;
    extern fn SetLoadFileDataCallback(callback: LoadFileDataCallback) void;
    extern fn SetSaveFileDataCallback(callback: SaveFileDataCallback) void;
    extern fn SetLoadFileTextCallback(callback: LoadFileTextCallback) void;
    extern fn SetSaveFileTextCallback(callback: SaveFileTextCallback) void;
};

pub const file = struct {
    extern fn LoadFileData(fileName: [*c]const u8, dataSize: [*c]c_int) [*c]u8;
    extern fn UnloadFileData(data: [*c]u8) void;
    extern fn SaveFileData(fileName: [*c]const u8, data: ?*anyopaque, dataSize: c_int) bool;
    extern fn ExportDataAsCode(data: [*c]const u8, dataSize: c_int, fileName: [*c]const u8) bool;
    extern fn LoadFileText(fileName: [*c]const u8) [*c]u8;
    extern fn UnloadFileText(text: [*c]u8) void;
    extern fn SaveFileText(fileName: [*c]const u8, text: [*c]const u8) bool;
    extern fn FileExists(fileName: [*c]const u8) bool;
    extern fn DirectoryExists(dirPath: [*c]const u8) bool;
    extern fn IsFileExtension(fileName: [*c]const u8, ext: [*c]const u8) bool;
    extern fn GetFileLength(fileName: [*c]const u8) c_int;
    extern fn GetFileExtension(fileName: [*c]const u8) [*c]const u8;
    extern fn GetFileName(filePath: [*c]const u8) [*c]const u8;
    extern fn GetFileNameWithoutExt(filePath: [*c]const u8) [*c]const u8;

    extern fn IsPathFile(path: [*c]const u8) bool;
    extern fn IsFileNameValid(fileName: [*c]const u8) bool;

    extern fn GetFileModTime(fileName: [*c]const u8) c_long;
};

pub const dir = struct {
    extern fn GetDirectoryPath(filePath: [*c]const u8) [*c]const u8;
    extern fn GetPrevDirectoryPath(dirPath: [*c]const u8) [*c]const u8;
    extern fn GetWorkingDirectory() [*c]const u8;
    extern fn GetApplicationDirectory() [*c]const u8;
    extern fn MakeDirectory(dirPath: [*c]const u8) c_int;
    extern fn ChangeDirectory(dir: [*c]const u8) bool;

    pub const FileList = extern struct {
        capacity: c_uint,
        count: c_uint,
        paths: [*c][*c]u8,

        extern fn LoadDirectoryFiles(dirPath: [*c]const u8) FileList;
        extern fn LoadDirectoryFilesEx(basePath: [*c]const u8, filter: [*c]const u8, scanSubdirs: bool) FileList;
        extern fn UnloadDirectoryFiles(files: FileList) void;
    };
};

pub const transform = struct {
    extern fn CompressData(data: [*c]const u8, dataSize: c_int, compDataSize: [*c]c_int) [*c]u8;
    extern fn DecompressData(compData: [*c]const u8, compDataSize: c_int, dataSize: [*c]c_int) [*c]u8;
    extern fn EncodeDataBase64(data: [*c]const u8, dataSize: c_int, outputSize: [*c]c_int) [*c]u8;
    extern fn DecodeDataBase64(text: [*c]const u8, outputSize: [*c]c_int) [*c]u8;
    extern fn ComputeCRC32(data: [*c]u8, dataSize: c_int) c_uint;
    extern fn ComputeMD5(data: [*c]u8, dataSize: c_int) [*c]c_uint;
    extern fn ComputeSHA1(data: [*c]u8, dataSize: c_int) [*c]c_uint;
};

pub const AutomationEvent = extern struct {
    frame: c_uint,
    type: c_uint,
    params: [4]c_int,

    extern fn StartAutomationEventRecording() void;
    extern fn StopAutomationEventRecording() void;
    extern fn PlayAutomationEvent(event: AutomationEvent) void;
};

pub const AutomationEventList = extern struct {
    capacity: c_uint,
    count: c_uint,
    events: [*c]AutomationEvent,

    extern fn LoadAutomationEventList(fileName: [*c]const u8) AutomationEventList;
    extern fn UnloadAutomationEventList(list: AutomationEventList) void;
    extern fn ExportAutomationEventList(list: AutomationEventList, fileName: [*c]const u8) bool;
    extern fn SetAutomationEventList(list: [*c]AutomationEventList) void;
    extern fn SetAutomationEventBaseFrame(frame: c_int) void;
};
