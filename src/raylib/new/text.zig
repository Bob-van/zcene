const std = @import("std");

const safety = @import("safety.zig");

const math = @import("math.zig");
const Vector2 = math.Vector2;

const r2D = @import("2D.zig");
const Color = r2D.Color;
const Rectangle = r2D.Rectangle;
const Image = r2D.Image;
const Texture = r2D.Texture;

pub const Codepoints = struct {
    data: []i32,

    pub const Error = error{InvalidCodepoint};

    extern fn LoadCodepoints(text: [*c]const u8, count: [*c]c_int) [*c]c_int;
    /// Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
    pub fn init(text: []const u8) Error!Codepoints {
        var len: c_int = 0;
        const ptr = LoadCodepoints(@ptrCast(text), &len);
        if (ptr == 0) return Error.InvalidCodepoint;
        safety.load();
        return .{ .data = ptr[0..@intCast(len)] };
    }

    extern fn UnloadCodepoints(codepoints: [*c]c_int) void;
    /// Unload codepoints data from memory
    pub fn deinit(self: Codepoints) void {
        safety.unload();
        UnloadCodepoints(@ptrCast(self.data));
    }

    pub const UTF8 = struct {
        text: [:0]u8,

        extern fn LoadUTF8(codepoints: [*c]const c_int, length: c_int) [*c]u8;
        /// Load UTF-8 text encoded from codepoints array
        pub fn init(codepoints: Codepoints) UTF8 {
            safety.load();
            return .{ .text = std.mem.span(LoadUTF8(@ptrCast(codepoints.data), @intCast(codepoints.data.len))) };
        }

        extern fn UnloadUTF8(text: [*c]u8) void;
        /// Unload UTF-8 text encoded from codepoints array
        pub fn deinit(utf8: UTF8) void {
            safety.unload();
            UnloadUTF8(@ptrCast(utf8.text));
        }
    };
};

pub const GlyphInfo = extern struct {
    value: c_int,
    offsetX: c_int,
    offsetY: c_int,
    advanceX: c_int,
    image: Image,

    pub const Error = error{InvalidFontData};

    extern fn LoadFontData(fileData: [*c]const u8, dataSize: c_int, fontSize: c_int, codepoints: [*c]c_int, codepointCount: c_int, @"type": c_int) [*c]GlyphInfo;
    /// Load font data for further use
    pub fn initFontData(fileData: []const u8, fontSize: i32, codePoints: ?[]i32, ty: Font.Type) Error![]GlyphInfo {
        var codePointsFinal: [*c]c_int = null;
        var codePointsLen: c_int = 95;
        if (codePoints) |codePointsSure| {
            codePointsFinal = @ptrCast(codePointsSure);
            codePointsLen = @intCast(codePointsSure.len);
        }
        const ptr = LoadFontData(@ptrCast(fileData), @intCast(fileData.len), fontSize, codePointsFinal, codePointsLen, @intFromEnum(ty));
        if (ptr == 0) return Error.InvalidFontData;
        for (0..@intCast(codePointsLen)) |_| safety.load();
        return ptr[0..@intCast(codePointsLen)];
    }

    extern fn UnloadFontData(glyphs: [*c]GlyphInfo, glyphCount: c_int) void;
    /// Unload font chars info data (RAM)
    pub fn deinitFontData(chars: []GlyphInfo) void {
        for (chars) |_| safety.unload();
        UnloadFontData(@ptrCast(chars), @intCast(chars.len));
    }
};

pub const Font = extern struct {
    baseSize: c_int,
    glyphCount: c_int,
    glyphPadding: c_int,
    texture: Texture,
    recs: [*c]Rectangle,
    glyphs: [*c]GlyphInfo,

    pub const Error = error{InvalidFont};

    pub const Type = enum(c_int) {
        default = 0,
        bitmap = 1,
        sdf = 2,
    };

    /// Check if a font is valid (font data loaded, WARNING: GPU texture not checked)
    extern fn IsFontValid(font: Font) bool;

    extern fn LoadFont(fileName: [*c]const u8) Font;
    /// Load font from file into GPU memory (VRAM)
    pub fn initFile(fileName: [:0]const u8) Error!Font {
        const font = LoadFont(@ptrCast(fileName));
        if (!IsFontValid(font)) return Error.InvalidFont;
        safety.load();
        return font;
    }

    extern fn LoadFontEx(fileName: [*c]const u8, fontSize: c_int, codepoints: [*c]const c_int, codepointCount: c_int) Font;
    /// Load font from file with extended parameters, use null for fontChars to load the default character set
    pub fn initFileEx(fileName: [:0]const u8, fontSize: i32, fontChars: ?[]i32) Error!Font {
        var fontCharsFinal: [*c]const c_int = null;
        var fontCharsLen: c_int = 0;
        if (fontChars) |fontCharsSure| {
            fontCharsFinal = @ptrCast(fontCharsSure);
            fontCharsLen = @intCast(fontCharsSure.len);
        }
        const font = LoadFontEx(@ptrCast(fileName), fontSize, fontCharsFinal, fontCharsLen);
        if (!IsFontValid(font)) return Error.InvalidFont;
        safety.load();
        return font;
    }

    extern fn LoadFontFromImage(image: Image, key: Color, firstChar: c_int) Font;
    /// Load font from Image (XNA style)
    pub fn initXNAImage(image: Image, key: Color, firstChar: i32) Error!Font {
        const font = LoadFontFromImage(image, key, firstChar);
        if (!IsFontValid(font)) return Error.InvalidFont;
        safety.load();
        return font;
    }

    extern fn LoadFontFromMemory(fileType: [*c]const u8, fileData: [*c]const u8, dataSize: c_int, fontSize: c_int, codepoints: [*c]const c_int, codepointCount: c_int) Font;
    /// Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
    pub fn initMemory(fileType: [:0]const u8, fileData: ?[]const u8, fontSize: i32, fontChars: ?[]i32) Error!Font {
        var fileDataFinal: [*c]const u8 = null;
        var fileDataLen: c_int = 0;
        if (fileData) |fileDataSure| {
            fileDataFinal = @ptrCast(fileDataSure);
            fileDataLen = @intCast(fileDataSure.len);
        }
        const cCount: c_int = if (fontChars) |fontCharsSure| @intCast(fontCharsSure.len) else 0;
        const font = LoadFontFromMemory(@ptrCast(fileType), @ptrCast(fileDataFinal), fileDataLen, fontSize, @ptrCast(fontChars), cCount);
        if (!IsFontValid(font)) return Error.InvalidFont;
        safety.load();
        return font;
    }

    extern fn UnloadFont(font: Font) void;
    /// Unload font from GPU memory (VRAM)
    pub fn deinit(self: Font) void {
        safety.unload();
        UnloadFont(self);
    }

    extern fn GetFontDefault() Font;
    /// Get the default Font (does not require deinit)
    pub fn default() Error!Font {
        const font = GetFontDefault();
        return if (IsFontValid(font)) font else Error.InvalidFont;
    }

    extern fn ExportFontAsCode(font: Font, fileName: [*c]const u8) bool;
    /// Export font as code file, returns true on success
    pub fn exportAsCode(self: Font, fileName: [:0]const u8) bool {
        return ExportFontAsCode(self, fileName);
    }

    extern fn DrawTextEx(font: Font, text: [*c]const u8, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void;
    /// Draw text using font and additional parameters
    pub fn drawTextEx(self: Font, text: [:0]const u8, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void {
        DrawTextEx(self, @ptrCast(text), position, fontSize, spacing, tint);
    }

    extern fn DrawTextPro(font: Font, text: [*c]const u8, position: Vector2, origin: Vector2, rotation: f32, fontSize: f32, spacing: f32, tint: Color) void;
    /// Draw text using Font and pro parameters (rotation)
    pub fn drawTextPro(self: Font, text: [:0]const u8, position: Vector2, origin: Vector2, rotation: f32, fontSize: f32, spacing: f32, tint: Color) void {
        DrawTextPro(self, @ptrCast(text), position, origin, rotation, fontSize, spacing, tint);
    }

    extern fn DrawTextCodepoint(font: Font, codepoint: c_int, position: Vector2, fontSize: f32, tint: Color) void;
    /// Draw one character (codepoint)
    pub fn drawCodepoint(self: Font, code_point: i32, position: Vector2, fontSize: f32, tint: Color) void {
        DrawTextCodepoint(self, code_point, position, fontSize, tint);
    }

    extern fn DrawTextCodepoints(font: Font, codepoints: [*c]const c_int, codepointCount: c_int, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void;
    /// Draw multiple character (codepoint)
    pub fn drawCodepoints(self: Font, codepoints: []const i32, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void {
        DrawTextCodepoints(self, @ptrCast(codepoints), @intCast(codepoints.len), position, fontSize, spacing, tint);
    }

    extern fn MeasureTextEx(font: Font, text: [*c]const u8, fontSize: f32, spacing: f32) Vector2;
    /// Measure string size for Font
    pub fn measureTextEx(self: Font, text: [:0]const u8, fontSize: f32, spacing: f32) Vector2 {
        return MeasureTextEx(self, @ptrCast(text), fontSize, spacing);
    }

    extern fn GetGlyphIndex(font: Font, codepoint: c_int) c_int;
    /// Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
    pub fn getGlyphIndex(self: Font, code_point: i32) i32 {
        return GetGlyphIndex(self, code_point);
    }

    extern fn GetGlyphInfo(font: Font, codepoint: c_int) GlyphInfo;
    /// Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
    pub fn getGlyphInfo(self: Font, code_point: i32) GlyphInfo {
        return GetGlyphInfo(self, code_point);
    }

    extern fn GetGlyphAtlasRec(font: Font, codepoint: c_int) Rectangle;
    /// Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
    pub fn getGlyphAtlasRec(self: Font, code_point: i32) Rectangle {
        return GetGlyphAtlasRec(self, code_point);
    }
};

extern fn DrawFPS(posX: c_int, posY: c_int) void;
/// Draw current FPS
pub fn drawFPS(posX: i32, posY: i32) void {
    DrawFPS(posX, posY);
}

extern fn DrawText(text: [*c]const u8, posX: c_int, posY: c_int, fontSize: c_int, color: Color) void;
/// Draw text (using default font)
pub fn draw(text: [:0]const u8, posX: i32, posY: i32, fontSize: i32, color: Color) void {
    DrawText(@ptrCast(text), posX, posY, fontSize, color);
}

/// Draw text using font and additional parameters
pub fn drawEx(font: Font, text: [:0]const u8, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void {
    font.drawTextEx(text, position, fontSize, spacing, tint);
}

/// Draw text using Font and pro parameters (rotation)
pub fn drawPro(font: Font, text: [:0]const u8, position: Vector2, origin: Vector2, rotation: f32, fontSize: f32, spacing: f32, tint: Color) void {
    font.drawTextPro(text, position, origin, rotation, fontSize, spacing, tint);
}

/// Draw one character (codepoint)
pub fn drawCodepoint(font: Font, code_point: i32, position: Vector2, fontSize: f32, tint: Color) void {
    font.drawCodepoint(code_point, position, fontSize, tint);
}

/// Draw multiple character (codepoint)
pub fn drawCodepoints(font: Font, codepoints: []const i32, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void {
    font.drawCodepoints(codepoints, position, fontSize, spacing, tint);
}

extern fn SetTextLineSpacing(spacing: c_int) void;
/// Set vertical line spacing when drawing with line-breaks
pub fn setLineSpacing(spacing: i32) void {
    SetTextLineSpacing(spacing);
}

extern fn MeasureText(text: [*c]const u8, fontSize: c_int) c_int;
/// Measure string width for default font
pub fn measure(text: [:0]const u8, fontSize: i32) i32 {
    return MeasureText(@ptrCast(text), fontSize);
}

/// Measure string size for Font
pub fn measureEx(font: Font, text: [:0]const u8, fontSize: f32, spacing: f32) Vector2 {
    return font.measureTextEx(text, fontSize, spacing);
}

/// Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
pub fn getGlyphIndex(font: Font, code_point: i32) i32 {
    return font.getGlyphIndex(code_point);
}

/// Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
pub fn getGlyphInfo(font: Font, code_point: i32) GlyphInfo {
    return font.getGlyphInfo(code_point);
}

/// Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
pub fn getGlyphAtlasRec(font: Font, code_point: i32) Rectangle {
    return font.getGlyphAtlasRec(code_point);
}

extern fn GetCodepointCount(text: [*c]const u8) c_int;
/// Get total number of codepoints in a UTF-8 encoded string
pub fn codepointCount(text: [:0]const u8) i32 {
    return GetCodepointCount(@ptrCast(text));
}

extern fn GetCodepoint(text: [*c]const u8, codepointSize: [*c]c_int) c_int;
/// Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
pub fn codepoint(text: [:0]const u8, codepointSize: *i32) i32 {
    return GetCodepoint(@ptrCast(text), codepointSize);
}

extern fn GetCodepointNext(text: [*c]const u8, codepointSize: [*c]c_int) c_int;
/// Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
pub fn codepointNext(text: [:0]const u8, codepointSize: *i32) i32 {
    return GetCodepointNext(@ptrCast(text), codepointSize);
}

extern fn GetCodepointPrevious(text: [*c]const u8, codepointSize: [*c]c_int) c_int;
/// Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
pub fn codepointPrev(text: [:0]const u8, codepointSize: *i32) i32 {
    return GetCodepointPrevious(@ptrCast(text), codepointSize);
}

extern fn CodepointToUTF8(codepoint: c_int, utf8Size: [*c]c_int) [*c]const u8;
/// Encode one codepoint into UTF-8 byte array (array length returned as parameter)
pub fn codepointToUTF8(code_point: i32) [:0]const u8 {
    var size: c_int = 0;
    const ptr = CodepointToUTF8(code_point, &size);
    return ptr[0..@intCast(size) :0];
}

/// Its here for compatibility but please dont use those!
///
/// Please just use the Zig std instead.
pub const dont = struct {
    extern fn LoadTextLines(text: [*c]const u8, count: [*c]c_int) [*c][*c]u8;
    // Load text as separate lines ('\n')
    pub fn initLines(text: [:0]const u8) error{InvalidText}![][*:0]u8 {
        var lineCount: c_int = 0;
        const ptr = LoadTextLines(@ptrCast(text), &lineCount);
        if (ptr == 0) return error.InvalidText;
        safety.load();
        return @ptrCast(ptr[0..@intCast(lineCount)]);
    }

    extern fn UnloadTextLines(text: [*c][*c]u8) void;
    /// Unload text lines
    pub fn deinitLines(text: [][*:0]const u8) void {
        safety.unload();
        UnloadTextLines(@ptrCast(text));
    }

    extern fn TextCopy(dst: [*c]u8, src: [*c]const u8) c_int;
    /// Copy one string to another, returns bytes copied
    pub fn copy(dst: *u8, src: [:0]const u8) i32 {
        return TextCopy(@ptrCast(dst), @ptrCast(src));
    }

    extern fn TextIsEqual(text1: [*c]const u8, text2: [*c]const u8) bool;
    /// Check if two text string are equal
    pub fn isEqual(text1: [:0]const u8, text2: [:0]const u8) bool {
        return TextIsEqual(@ptrCast(text1), @ptrCast(text2));
    }

    extern fn TextLength(text: [*c]const u8) c_uint;
    /// Get text length, checks for '\0' ending
    pub fn length(text: [:0]const u8) u32 {
        return TextLength(@ptrCast(text));
    }

    extern fn TextFormat(text: [*c]const u8, ...) [*c]const u8;
    /// Text formatting with variables (sprintf() style)
    pub fn format(text: [:0]const u8, args: anytype) [:0]const u8 {
        comptime {
            const info = @typeInfo(@TypeOf(args));
            switch (info) {
                .@"struct" => {
                    if (!info.@"struct".is_tuple)
                        @compileError("Args should be in a tuple (call this function like textFormat(.{arg1, arg2, ...});)!");
                },
                else => {
                    @compileError("Args should be in a tuple (call this function like textFormat(.{arg1, arg2, ...});)!");
                },
            }
        }

        return std.mem.span(@call(.auto, TextFormat, .{@as([*c]const u8, @ptrCast(text))} ++ args));
    }

    extern fn TextSubtext(text: [*c]const u8, position: c_int, length: c_int) [*c]const u8;
    /// Get a piece of a text string
    pub fn subtext(text: [:0]const u8, position: i32, out_length: i32) [:0]const u8 {
        return std.mem.span(TextSubtext(@ptrCast(text), position, out_length));
    }

    extern fn TextReplace(text: [*c]const u8, replace: [*c]const u8, by: [*c]const u8) [*c]u8;
    /// Replace text string (WARNING: memory must be freed!)
    pub fn replace(text: [:0]const u8, replace_val: [:0]const u8, by_val: [:0]const u8) [:0]u8 {
        return std.mem.span(TextReplace(@ptrCast(text), @ptrCast(replace_val), @ptrCast(by_val)));
    }

    extern fn TextInsert(text: [*c]const u8, insert: [*c]const u8, position: c_int) [*c]u8;
    /// Insert text in a position (WARNING: memory must be freed!)
    pub fn insert(text: [:0]const u8, insert_val: [:0]const u8, position: i32) [:0]u8 {
        return std.mem.span(TextInsert(@ptrCast(text), @ptrCast(insert_val), position));
    }

    extern fn TextJoin(textList: [*c][*c]u8, count: c_int, delimiter: [*c]const u8) [*c]u8;
    /// Join text strings with delimiter
    pub fn join(textList: [][:0]u8, delimiter: [:0]const u8) [:0]const u8 {
        return std.mem.span(TextJoin(@ptrCast(textList), @intCast(textList.len), @ptrCast(delimiter)));
    }

    extern fn TextSplit(text: [*c]const u8, delimiter: u8, count: [*c]c_int) [*c][*c]u8;
    /// Split text into multiple strings, using MAX_TEXTSPLIT_COUNT static strings
    pub fn textSplit(text: []const u8, delimiter: u8) error{InvalidText}![][*:0]u8 {
        var len: c_int = 0;
        const ptr = TextSplit(@ptrCast(text), delimiter, &len);
        if (ptr == 0) return error.InvalidText;
        return @ptrCast(ptr[0..@intCast(len)]);
    }

    extern fn TextAppend(text: [*c]u8, append: [*c]const u8, position: [*c]c_int) void;
    /// Append text at specific position and move cursor!
    pub fn append(text: [:0]u8, append_val: [:0]const u8, position: *i32) void {
        TextAppend(@ptrCast(text), @ptrCast(append_val), @ptrCast(position));
    }

    extern fn TextFindIndex(text: [*c]const u8, find: [*c]const u8) c_int;
    /// Find first text occurrence within a string, -1 if not found
    pub fn findIndex(text: [:0]const u8, find: [:0]const u8) i32 {
        return TextFindIndex(@ptrCast(text), @ptrCast(find));
    }

    extern fn TextToUpper(text: [*c]const u8) [*c]u8;
    /// Get upper case version of provided string
    pub fn toUpper(text: [:0]const u8) [:0]u8 {
        return std.mem.span(TextToUpper(@ptrCast(text)));
    }

    extern fn TextToLower(text: [*c]const u8) [*c]u8;
    /// Get lower case version of provided string
    pub fn toLower(text: [:0]const u8) [:0]u8 {
        return std.mem.span(TextToLower(@ptrCast(text)));
    }

    extern fn TextToPascal(text: [*c]const u8) [*c]u8;
    /// Get Pascal case notation version of provided string
    pub fn toPascal(text: [:0]const u8) [:0]u8 {
        return std.mem.span(TextToPascal(@ptrCast(text)));
    }

    extern fn TextToSnake(text: [*c]const u8) [*c]u8;
    /// Get Snake case notation version of provided string
    pub fn toSnake(text: [:0]const u8) [:0]u8 {
        return std.mem.span(TextToSnake(@ptrCast(text)));
    }

    extern fn TextToCamel(text: [*c]const u8) [*c]u8;
    /// Get Camel case notation version of provided string
    pub fn toCamel(text: [:0]const u8) [:0]u8 {
        return std.mem.span(TextToCamel(@ptrCast(text)));
    }

    extern fn TextToInteger(text: [*c]const u8) c_int;
    /// Get integer value from text
    pub fn toInteger(text: [:0]const u8) i32 {
        return TextToInteger(@ptrCast(text));
    }

    extern fn TextToFloat(text: [*c]const u8) f32;
    /// Get float value from text
    pub fn toFloat(text: [:0]const u8) f32 {
        return TextToFloat(@ptrCast(text));
    }
};
