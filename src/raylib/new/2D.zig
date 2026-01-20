const safety = @import("safety.zig");

const math = @import("math.zig");
const Vector2 = math.Vector2;
const Vector3 = math.Vector3;
const Vector4 = math.Vector4;

const txt = @import("text.zig");
const GlyphInfo = txt.GlyphInfo;
const Font = txt.Font;

pub const Camera = @import("camera.zig").r2D;
pub const draw = @import("draw.zig").r2D;
pub const collision = @import("collision.zig").r2D;

pub const PixelFormat = enum(c_int) {
    uncompressed_grayscale = 1,
    uncompressed_gray_alpha = 2,
    uncompressed_r5g6b5 = 3,
    uncompressed_r8g8b8 = 4,
    uncompressed_r5g5b5a1 = 5,
    uncompressed_r4g4b4a4 = 6,
    uncompressed_r8g8b8a8 = 7,
    uncompressed_r32 = 8,
    uncompressed_r32g32b32 = 9,
    uncompressed_r32g32b32a32 = 10,
    uncompressed_r16 = 11,
    uncompressed_r16g16b16 = 12,
    uncompressed_r16g16b16a16 = 13,
    compressed_dxt1_rgb = 14,
    compressed_dxt1_rgba = 15,
    compressed_dxt3_rgba = 16,
    compressed_dxt5_rgba = 17,
    compressed_etc1_rgb = 18,
    compressed_etc2_rgb = 19,
    compressed_etc2_eac_rgba = 20,
    compressed_pvrt_rgb = 21,
    compressed_pvrt_rgba = 22,
    compressed_astc_4x4_rgba = 23,
    compressed_astc_8x8_rgba = 24,
};

pub const CubemapLayout = enum(c_int) {
    auto_detect = 0,
    line_vertical = 1,
    line_horizontal = 2,
    cross_three_by_four = 3,
    cross_four_by_three = 4,
};

pub const Color = extern struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,

    pub const light_gray = Color.init(200, 200, 200, 255);
    pub const gray = Color.init(130, 130, 130, 255);
    pub const dark_gray = Color.init(80, 80, 80, 255);
    pub const yellow = Color.init(253, 249, 0, 255);
    pub const gold = Color.init(255, 203, 0, 255);
    pub const orange = Color.init(255, 161, 0, 255);
    pub const pink = Color.init(255, 109, 194, 255);
    pub const red = Color.init(230, 41, 55, 255);
    pub const maroon = Color.init(190, 33, 55, 255);
    pub const green = Color.init(0, 228, 48, 255);
    pub const lime = Color.init(0, 158, 47, 255);
    pub const dark_green = Color.init(0, 117, 44, 255);
    pub const sky_blue = Color.init(102, 191, 255, 255);
    pub const blue = Color.init(0, 121, 241, 255);
    pub const dark_blue = Color.init(0, 82, 172, 255);
    pub const purple = Color.init(200, 122, 255, 255);
    pub const violet = Color.init(135, 60, 190, 255);
    pub const dark_purple = Color.init(112, 31, 126, 255);
    pub const beige = Color.init(211, 176, 131, 255);
    pub const brown = Color.init(127, 106, 79, 255);
    pub const dark_brown = Color.init(76, 63, 47, 255);

    pub const white = Color.init(255, 255, 255, 255);
    pub const black = Color.init(0, 0, 0, 255);
    pub const blank = Color.init(0, 0, 0, 0);
    pub const magenta = Color.init(255, 0, 255, 255);
    pub const ray_white = Color.init(245, 245, 245, 255);

    pub fn init(r: u8, g: u8, b: u8, a: u8) Color {
        return Color{ .r = r, .g = g, .b = b, .a = a };
    }

    extern fn GetColor(hexValue: c_uint) Color;
    /// Get a Color from hexadecimal value
    pub fn initHex(hexValue: u32) Color {
        return GetColor(hexValue);
    }

    extern fn ColorFromNormalized(normalized: Vector4) Color;
    /// Get Color from normalized values [0..1]
    pub fn initNormalized(normalized: Vector4) Color {
        return ColorFromNormalized(normalized);
    }

    extern fn ColorFromHSV(hue: f32, saturation: f32, value: f32) Color;
    /// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
    pub fn initHSV(hue: f32, saturation: f32, value: f32) Color {
        return ColorFromHSV(hue, saturation, value);
    }

    extern fn GetPixelColor(srcPtr: ?*anyopaque, format: c_int) Color;
    /// Get Color from a source pixel pointer of certain format
    pub fn initPixelPtr(srcPtr: *anyopaque, format: PixelFormat) Color {
        return GetPixelColor(srcPtr, @intFromEnum(format));
    }

    extern fn ColorIsEqual(col1: Color, col2: Color) bool;
    /// Check if two colors are equal
    pub fn equal(self: Color, other: Color) bool {
        return ColorIsEqual(self, other);
    }

    extern fn Fade(color: Color, alpha: f32) Color;
    /// Get color with alpha applied, alpha goes from 0.0 to 1.0
    pub fn fade(self: Color, a: f32) Color {
        return Fade(self, a);
    }

    extern fn ColorTint(color: Color, tint: Color) Color;
    /// Get color multiplied with another color
    pub fn tint(self: Color, t: Color) Color {
        return ColorTint(self, t);
    }

    extern fn ColorNormalize(color: Color) Vector4;
    /// Get Color normalized as float [0..1]
    pub fn normalize(self: Color) Vector4 {
        return ColorNormalize(self);
    }

    extern fn ColorBrightness(color: Color, factor: f32) Color;
    /// Get color with brightness correction, brightness factor goes from -1.0 to 1.0
    pub fn brightness(self: Color, factor: f32) Color {
        return ColorBrightness(self, factor);
    }

    extern fn ColorContrast(color: Color, contrast: f32) Color;
    /// Get color with contrast correction, contrast values between -1.0 and 1.0
    pub fn contrast(self: Color, c: f32) Color {
        return ColorContrast(self, c);
    }

    extern fn ColorAlpha(color: Color, alpha: f32) Color;
    /// Get color with alpha applied, alpha goes from 0.0 to 1.0
    pub fn alpha(self: Color, a: f32) Color {
        return ColorAlpha(self, a);
    }

    extern fn GetPixelDataSize(width: c_int, height: c_int, format: c_int) c_int;
    /// Get pixel data size in bytes for certain format
    pub fn getPixelPtrSize(width: i32, height: i32, format: PixelFormat) i32 {
        return GetPixelDataSize(width, height, @intFromEnum(format));
    }

    extern fn ColorToInt(color: Color) c_int;
    /// Get hexadecimal value for a Color
    pub fn toHex(self: Color) u32 {
        return @bitCast(ColorToInt(self));
    }

    extern fn ColorToHSV(color: Color) Vector3;
    /// Get HSV values for a Color, hue [0..360], saturation/value [0..1]
    pub fn toHSV(self: Color) Vector3 {
        return ColorToHSV(self);
    }

    extern fn SetPixelColor(dstPtr: ?*anyopaque, color: Color, format: c_int) void;
    /// Set color formatted into destination pixel pointer
    pub fn toPixelPtr(self: Color, dstPtr: ?*anyopaque, format: PixelFormat) void {
        SetPixelColor(dstPtr, self, @intFromEnum(format));
    }

    extern fn ColorAlphaBlend(dst: Color, src: Color, tint: Color) Color;
    /// Get src alpha-blended into dst color with tint
    pub fn alphaBlend(dst: Color, src: Color, color_tint: Color) Color {
        return ColorAlphaBlend(dst, src, color_tint);
    }

    extern fn ColorLerp(color1: Color, color2: Color, factor: f32) Color;
    /// Get color lerp interpolation between two colors, factor [0.0f..1.0f]
    pub fn lerp(self: Color, other: Color, factor: f32) Color {
        return ColorLerp(self, other, factor);
    }
};

pub const Rectangle = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,

    pub fn init(x: f32, y: f32, width: f32, height: f32) Rectangle {
        return Rectangle{ .x = x, .y = y, .width = width, .height = height };
    }

    extern fn DrawRectangleRec(rec: Rectangle, color: Color) void;
    /// Draw a color-filled rectangle
    pub fn draw(self: Rectangle, color: Color) void {
        safety.drawingBegun();
        DrawRectangleRec(self, color);
    }

    extern fn DrawRectanglePro(rec: Rectangle, origin: Vector2, rotation: f32, color: Color) void;
    /// Draw a color-filled rectangle with pro parameters
    pub fn drawPro(self: Rectangle, origin: Vector2, rotation: f32, color: Color) void {
        safety.drawingBegun();
        DrawRectanglePro(self, origin, rotation, color);
    }

    extern fn DrawRectangleGradientEx(rec: Rectangle, topLeft: Color, bottomLeft: Color, bottomRight: Color, topRight: Color) void;
    /// Draw a gradient-filled rectangle with custom vertex colors
    pub fn drawGradientEx(self: Rectangle, topLeft: Color, bottomLeft: Color, bottomRight: Color, topRight: Color) void {
        safety.drawingBegun();
        DrawRectangleGradientEx(self, topLeft, bottomLeft, bottomRight, topRight);
    }

    extern fn DrawRectangleLinesEx(rec: Rectangle, lineThick: f32, color: Color) void;
    /// Draw rectangle outline with extended parameters
    pub fn drawLinesEx(self: Rectangle, lineThick: f32, color: Color) void {
        safety.drawingBegun();
        DrawRectangleLinesEx(self, lineThick, color);
    }

    extern fn DrawRectangleRounded(rec: Rectangle, roundness: f32, segments: c_int, color: Color) void;
    /// Draw rectangle with rounded edges
    pub fn drawRounded(self: Rectangle, roundness: f32, segments: i32, color: Color) void {
        safety.drawingBegun();
        DrawRectangleRounded(self, roundness, segments, color);
    }

    extern fn DrawRectangleRoundedLines(rec: Rectangle, roundness: f32, segments: c_int, color: Color) void;
    /// Draw rectangle lines with rounded edges
    pub fn drawRoundedLines(self: Rectangle, roundness: f32, segments: i32, color: Color) void {
        safety.drawingBegun();
        DrawRectangleRoundedLines(self, roundness, segments, color);
    }

    extern fn DrawRectangleRoundedLinesEx(rec: Rectangle, roundness: f32, segments: c_int, lineThick: f32, color: Color) void;
    /// Draw rectangle with rounded edges outline
    pub fn drawRoundedLinesEx(self: Rectangle, roundness: f32, segments: i32, lineThick: f32, color: Color) void {
        safety.drawingBegun();
        DrawRectangleRoundedLinesEx(self, roundness, segments, lineThick, color);
    }

    extern fn CheckCollisionRecs(rec1: Rectangle, rec2: Rectangle) bool;
    /// Check collision between two rectangles
    pub fn checkCollision(self: Rectangle, other: Rectangle) bool {
        return CheckCollisionRecs(self, other);
    }

    extern fn GetCollisionRec(rec1: Rectangle, rec2: Rectangle) Rectangle;
    /// Get collision rectangle for two rectangles collision
    pub fn getCollision(self: Rectangle, other: Rectangle) Rectangle {
        return GetCollisionRec(self, other);
    }

    extern fn CheckCollisionPointRec(point: Vector2, rec: Rectangle) bool;
    /// Check if point is inside rectangle
    pub fn checkCollisionPoint(self: Rectangle, point: Vector2) bool {
        return CheckCollisionPointRec(point, self);
    }

    extern fn CheckCollisionCircleRec(center: Vector2, radius: f32, rec: Rectangle) bool;
    /// Check collision between circle and rectangle
    pub fn checkCollisionCircle(self: Rectangle, center: Vector2, radius: f32) bool {
        return CheckCollisionCircleRec(center, radius, self);
    }
};

pub const Image = extern struct {
    data: *anyopaque,
    width: c_int,
    height: c_int,
    mipmaps: c_int,
    format: PixelFormat,

    pub const Error = error{InvalidImage};

    /// Check if an image is valid (data and parameters)
    extern fn IsImageValid(image: Image) bool;

    extern fn LoadImage(fileName: [*c]const u8) Image;
    /// Load image from file into CPU memory (RAM)
    pub fn initFile(fileName: [:0]const u8) Error!Image {
        const image = LoadImage(@ptrCast(fileName));
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return image;
    }

    extern fn LoadImageFromMemory(fileType: [*c]const u8, fileData: [*c]const u8, dataSize: c_int) Image;
    /// Load image from memory buffer, fileType refers to extension: i.e. '.png'
    pub fn initMemory(fileType: [:0]const u8, fileData: []const u8) Error!Image {
        const image = LoadImageFromMemory(@ptrCast(fileType), @ptrCast(fileData), @intCast(fileData.len));
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return image;
    }

    extern fn LoadImageRaw(fileName: [*c]const u8, width: c_int, height: c_int, format: c_int, headerSize: c_int) Image;
    /// Load image from RAW file data
    pub fn initRaw(fileName: [:0]const u8, width: i32, height: i32, format: PixelFormat, headerSize: i32) Error!Image {
        const image = LoadImageRaw(@ptrCast(fileName), width, height, @intFromEnum(format), headerSize);
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return image;
    }

    extern fn LoadImageAnim(fileName: [*c]const u8, frames: [*c]c_int) Image;
    /// Load image sequence from file (frames appended to image.data)
    pub fn initAnimFile(fileName: [:0]const u8, frames: *i32) Error!Image {
        const image = LoadImageAnim(@ptrCast(fileName), @ptrCast(frames));
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return image;
    }

    extern fn LoadImageAnimFromMemory(fileType: [*c]const u8, fileData: [*c]const u8, dataSize: c_int, frames: [*c]c_int) Image;
    /// Load image sequence from memory buffer, fileType refers to extension: i.e. '.png'
    pub fn initAnimMemory(fileType: [:0]const u8, fileData: []const u8, frames: *i32) Error!Image {
        const image = LoadImageAnimFromMemory(@ptrCast(fileType), @ptrCast(fileData), @intCast(fileData.len), @ptrCast(frames));
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return image;
    }

    extern fn LoadImageFromTexture(texture: Texture) Image;
    /// Load image from GPU texture data
    pub fn initTexture(texture: Texture) Error!Image {
        const image = LoadImageFromTexture(texture);
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return image;
    }

    extern fn LoadImageFromScreen() Image;
    /// Load image from screen buffer and (screenshot)
    pub fn initScreen() Error!Image {
        const image = LoadImageFromScreen();
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return image;
    }

    extern fn ImageText(text: [*c]const u8, fontSize: c_int, color: Color) Image;
    /// Create an image from text (default font)
    pub fn initText(text: [:0]const u8, fontSize: i32, color: Color) Error!Image {
        const image = ImageText(@ptrCast(text), fontSize, color);
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return image;
    }

    extern fn ImageTextEx(font: Font, text: [*c]const u8, fontSize: f32, spacing: f32, tint: Color) Image;
    /// Create an image from text (custom sprite font)
    pub fn initTextEx(font: Font, text: [:0]const u8, fontSize: f32, spacing: f32, color_tint: Color) Error!Image {
        const image = ImageTextEx(font, @ptrCast(text), fontSize, spacing, color_tint);
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return image;
    }

    extern fn UnloadImage(image: Image) void;
    /// Unload image from CPU memory (RAM)
    pub fn deinit(self: Image) void {
        safety.unload();
        UnloadImage(self);
    }

    extern fn GenImageColor(width: c_int, height: c_int, color: Color) Image;
    /// Generate image: plain color
    pub fn initColor(width: i32, height: i32, color: Color) Image {
        safety.load();
        return GenImageColor(width, height, color);
    }

    extern fn GenImageGradientLinear(width: c_int, height: c_int, direction: c_int, start: Color, end: Color) Image;
    /// Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
    pub fn initGradientLinear(width: i32, height: i32, direction: i32, start: Color, end: Color) Image {
        safety.load();
        return GenImageGradientLinear(width, height, direction, start, end);
    }

    extern fn GenImageGradientRadial(width: c_int, height: c_int, density: f32, inner: Color, outer: Color) Image;
    /// Generate image: radial gradient
    pub fn initGradientRadial(width: i32, height: i32, density: f32, inner: Color, outer: Color) Image {
        safety.load();
        return GenImageGradientRadial(width, height, density, inner, outer);
    }

    extern fn GenImageGradientSquare(width: c_int, height: c_int, density: f32, inner: Color, outer: Color) Image;
    /// Generate image: square gradient
    pub fn initGradientSquare(width: i32, height: i32, density: f32, inner: Color, outer: Color) Image {
        safety.load();
        return GenImageGradientSquare(width, height, density, inner, outer);
    }

    extern fn GenImageChecked(width: c_int, height: c_int, checksX: c_int, checksY: c_int, col1: Color, col2: Color) Image;
    /// Generate image: checked
    pub fn initChecked(width: i32, height: i32, checksX: i32, checksY: i32, col1: Color, col2: Color) Image {
        safety.load();
        return GenImageChecked(width, height, checksX, checksY, col1, col2);
    }

    extern fn GenImageWhiteNoise(width: c_int, height: c_int, factor: f32) Image;
    /// Generate image: white noise
    pub fn initWhiteNoise(width: i32, height: i32, factor: f32) Image {
        safety.load();
        return GenImageWhiteNoise(width, height, factor);
    }

    extern fn GenImagePerlinNoise(width: c_int, height: c_int, offsetX: c_int, offsetY: c_int, scale: f32) Image;
    /// Generate image: perlin noise
    pub fn initPerlinNoise(width: i32, height: i32, offsetX: i32, offsetY: i32, scale: f32) Image {
        safety.load();
        return GenImagePerlinNoise(width, height, offsetX, offsetY, scale);
    }

    extern fn GenImageCellular(width: c_int, height: c_int, tileSize: c_int) Image;
    /// Generate image: cellular algorithm, bigger tileSize means bigger cells
    pub fn initCellular(width: i32, height: i32, tileSize: i32) Image {
        safety.load();
        return GenImageCellular(width, height, tileSize);
    }

    extern fn GenImageText(width: c_int, height: c_int, text: [*c]const u8) Image;
    /// Generate image: grayscale image from text data
    pub fn initTextGrayscale(width: i32, height: i32, text: [:0]const u8) Image {
        safety.load();
        return GenImageText(width, height, @ptrCast(text));
    }

    extern fn ImageFromChannel(image: Image, selectedChannel: c_int) Image;
    /// Create an image from a selected channel of another image (GRAYSCALE)
    pub fn initChannel(image: Image, selectedChannel: i32) Image {
        safety.load();
        return ImageFromChannel(image, selectedChannel);
    }

    extern fn GenImageFontAtlas(glyphs: [*c]const GlyphInfo, glyphRecs: [*c][*c]Rectangle, glyphCount: c_int, fontSize: c_int, padding: c_int, packMethod: c_int) Image;
    /// Generate image font atlas using chars info
    pub fn initFontAtlas(glyphs: []const GlyphInfo, fontSize: i32, padding: i32, packMethod: i32) Error!struct { Image, []Rectangle } {
        var recs: [*c]Rectangle = null;
        const image = GenImageFontAtlas(@ptrCast(glyphs), @as([*c][*c]Rectangle, @ptrCast(&recs)), @intCast(glyphs.len), fontSize, padding, packMethod);
        if (!IsImageValid(image)) return Error.InvalidImage;
        safety.load();
        return .{ image, recs[0..@intCast(glyphs.len)] };
    }

    extern fn ImageCopy(image: Image) Image;
    /// Create an image duplicate (useful for transformations)
    pub fn copy(image: Image) Image {
        return ImageCopy(image);
    }

    extern fn ImageFromImage(image: Image, rec: Rectangle) Image;
    /// Create an image from another image piece
    pub fn copyRec(self: Image, rec: Rectangle) Image {
        return ImageFromImage(self, rec);
    }

    extern fn ImageFormat(image: [*c]Image, newFormat: c_int) void;
    /// Convert image data to desired format
    pub fn setFormat(self: *Image, newFormat: PixelFormat) void {
        return ImageFormat(@ptrCast(self), @intFromEnum(newFormat));
    }

    extern fn ImageToPOT(image: [*c]Image, fill: Color) void;
    /// Convert image to POT (power-of-two)
    pub fn toPOT(self: *Image, fill: Color) void {
        ImageToPOT(@ptrCast(self), fill);
    }

    extern fn ImageCrop(image: [*c]Image, crop: Rectangle) void;
    /// Crop an image to a defined rectangle
    pub fn crop(self: *Image, c: Rectangle) void {
        ImageCrop(@ptrCast(self), c);
    }

    extern fn ImageAlphaCrop(image: [*c]Image, threshold: f32) void;
    /// Crop image depending on alpha value
    pub fn alphaCrop(self: *Image, threshold: f32) void {
        ImageAlphaCrop(@ptrCast(self), threshold);
    }

    extern fn ImageAlphaClear(image: [*c]Image, color: Color, threshold: f32) void;
    /// Clear alpha channel to desired color
    pub fn alphaClear(self: *Image, color: Color, threshold: f32) void {
        ImageAlphaClear(@ptrCast(self), color, threshold);
    }

    extern fn ImageAlphaMask(image: [*c]Image, alphaMask: Image) void;
    /// Apply alpha mask to image
    pub fn alphaMask(self: *Image, am: Image) void {
        ImageAlphaMask(@ptrCast(self), am);
    }

    extern fn ImageAlphaPremultiply(image: [*c]Image) void;
    /// Premultiply alpha channel
    pub fn alphaPremultiply(self: *Image) void {
        ImageAlphaPremultiply(@ptrCast(self));
    }

    extern fn ImageBlurGaussian(image: [*c]Image, blurSize: c_int) void;
    /// Apply Gaussian blur using a box blur approximation
    pub fn blurGaussian(self: *Image, blurSize: i32) void {
        ImageBlurGaussian(@ptrCast(self), blurSize);
    }

    extern fn ImageKernelConvolution(image: [*c]Image, kernel: [*c]const f32, kernelSize: c_int) void;
    /// Apply custom square convolution kernel to image
    pub fn kernelConvolution(image: *Image, kernel: []const f32) void {
        ImageKernelConvolution(@ptrCast(image), @ptrCast(kernel), @intCast(kernel.len));
    }

    extern fn ImageResize(image: [*c]Image, newWidth: c_int, newHeight: c_int) void;
    /// Resize image (Bicubic scaling algorithm)
    pub fn resize(self: *Image, newWidth: i32, newHeight: i32) void {
        ImageResize(@ptrCast(self), newWidth, newHeight);
    }

    extern fn ImageResizeNN(image: [*c]Image, newWidth: c_int, newHeight: c_int) void;
    /// Resize image (Nearest-Neighbor scaling algorithm)
    pub fn resizeNN(self: *Image, newWidth: i32, newHeight: i32) void {
        ImageResizeNN(@ptrCast(self), newWidth, newHeight);
    }

    extern fn ImageResizeCanvas(image: [*c]Image, newWidth: c_int, newHeight: c_int, offsetX: c_int, offsetY: c_int, fill: Color) void;
    /// Resize canvas and fill with color
    pub fn resizeCanvas(self: *Image, newWidth: i32, newHeight: i32, offsetX: i32, offsetY: i32, fill: Color) void {
        ImageResizeCanvas(@ptrCast(self), newWidth, newHeight, offsetX, offsetY, fill);
    }

    extern fn ImageMipmaps(image: [*c]Image) void;
    /// Compute all mipmap levels for a provided image
    pub fn mimaps(self: *Image) void {
        ImageMipmaps(@ptrCast(self));
    }

    extern fn ImageDither(image: [*c]Image, rBpp: c_int, gBpp: c_int, bBpp: c_int, aBpp: c_int) void;
    /// Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
    pub fn dither(self: *Image, rBpp: i32, gBpp: i32, bBpp: i32, aBpp: i32) void {
        ImageDither(@ptrCast(self), rBpp, gBpp, bBpp, aBpp);
    }

    extern fn ImageFlipVertical(image: [*c]Image) void;
    /// Flip image vertically
    pub fn flipVertical(self: *Image) void {
        ImageFlipVertical(@ptrCast(self));
    }

    extern fn ImageFlipHorizontal(image: [*c]Image) void;
    /// Flip image horizontally
    pub fn flipHorizontal(self: *Image) void {
        ImageFlipHorizontal(@ptrCast(self));
    }

    extern fn ImageRotate(image: [*c]Image, degrees: c_int) void;
    /// Rotate image by input angle in degrees (-359 to 359)
    pub fn rotate(self: *Image, degrees: i32) void {
        ImageRotate(@ptrCast(self), degrees);
    }

    extern fn ImageRotateCW(image: [*c]Image) void;
    /// Rotate image clockwise 90deg
    pub fn rotateCW(self: *Image) void {
        ImageRotateCW(@ptrCast(self));
    }

    extern fn ImageRotateCCW(image: [*c]Image) void;
    /// Rotate image counter-clockwise 90deg
    pub fn rotateCCW(self: *Image) void {
        ImageRotateCCW(@ptrCast(self));
    }

    extern fn ImageColorTint(image: [*c]Image, color: Color) void;
    /// Modify image color: tint
    pub fn tint(self: *Image, color: Color) void {
        ImageColorTint(@ptrCast(self), color);
    }

    extern fn ImageColorInvert(image: [*c]Image) void;
    /// Modify image color: invert
    pub fn invert(self: *Image) void {
        ImageColorInvert(@ptrCast(self));
    }

    extern fn ImageColorGrayscale(image: [*c]Image) void;
    /// Modify image color: grayscale
    pub fn grayscale(self: *Image) void {
        ImageColorGrayscale(@ptrCast(self));
    }

    extern fn ImageColorContrast(image: [*c]Image, contrast: f32) void;
    /// Modify image color: contrast (-100 to 100)
    pub fn contrast(self: *Image, c: f32) void {
        ImageColorContrast(@ptrCast(self), c);
    }

    extern fn ImageColorBrightness(image: [*c]Image, brightness: c_int) void;
    /// Modify image color: brightness (-255 to 255)
    pub fn brightness(self: *Image, b: i32) void {
        ImageColorBrightness(@ptrCast(self), b);
    }

    extern fn ImageColorReplace(image: [*c]Image, color: Color, replace: Color) void;
    /// Modify image color: replace color
    pub fn replaceColor(self: *Image, color: Color, replace: Color) void {
        ImageColorReplace(@ptrCast(self), color, replace);
    }

    extern fn GetImageAlphaBorder(image: Image, threshold: f32) Rectangle;
    /// Get image alpha border rectangle
    pub fn getAlphaBorder(self: Image, threshold: f32) Rectangle {
        return GetImageAlphaBorder(self, threshold);
    }

    extern fn GetImageColor(image: Image, x: c_int, y: c_int) Color;
    /// Get image pixel color at (x, y) position
    pub fn getColor(self: Image, x: i32, y: i32) Color {
        return GetImageColor(self, x, y);
    }

    extern fn ImageClearBackground(dst: [*c]Image, color: Color) void;
    /// Clear image background with given color
    pub fn clearBackground(self: *Image, color: Color) void {
        ImageClearBackground(@ptrCast(self), color);
    }

    extern fn ImageDrawPixel(dst: [*c]Image, posX: c_int, posY: c_int, color: Color) void;
    /// Draw pixel within an image
    pub fn drawPixel(self: *Image, posX: i32, posY: i32, color: Color) void {
        ImageDrawPixel(@ptrCast(self), posX, posY, color);
    }

    extern fn ImageDrawPixelV(dst: [*c]Image, position: Vector2, color: Color) void;
    /// Draw pixel within an image (Vector version)
    pub fn drawPixelV(self: *Image, position: Vector2, color: Color) void {
        ImageDrawPixelV(@ptrCast(self), position, color);
    }

    extern fn ImageDrawLine(dst: [*c]Image, startPosX: c_int, startPosY: c_int, endPosX: c_int, endPosY: c_int, color: Color) void;
    /// Draw line within an image
    pub fn drawLine(self: *Image, startPosX: i32, startPosY: i32, endPosX: i32, endPosY: i32, color: Color) void {
        ImageDrawLine(@ptrCast(self), startPosX, startPosY, endPosX, endPosY, color);
    }

    extern fn ImageDrawLineV(dst: [*c]Image, start: Vector2, end: Vector2, color: Color) void;
    /// Draw line within an image (Vector version)
    pub fn drawLineV(self: *Image, start: Vector2, end: Vector2, color: Color) void {
        ImageDrawLineV(@ptrCast(self), start, end, color);
    }

    extern fn ImageDrawLineEx(dst: [*c]Image, start: Vector2, end: Vector2, thick: c_int, color: Color) void;
    /// Draw a line defining thickness within an image
    pub fn drawLineEx(dst: *Image, start: Vector2, end: Vector2, thick: i32, color: Color) void {
        ImageDrawLineEx(@ptrCast(dst), start, end, thick, color);
    }

    extern fn ImageDrawCircle(dst: [*c]Image, centerX: c_int, centerY: c_int, radius: c_int, color: Color) void;
    /// Draw a filled circle within an image
    pub fn drawCircle(self: *Image, centerX: i32, centerY: i32, radius: i32, color: Color) void {
        ImageDrawCircle(@ptrCast(self), centerX, centerY, radius, color);
    }

    extern fn ImageDrawCircleV(dst: [*c]Image, center: Vector2, radius: c_int, color: Color) void;
    /// Draw a filled circle within an image (Vector version)
    pub fn drawCircleV(self: *Image, center: Vector2, radius: i32, color: Color) void {
        ImageDrawCircleV(@ptrCast(self), center, radius, color);
    }

    extern fn ImageDrawCircleLines(dst: [*c]Image, centerX: c_int, centerY: c_int, radius: c_int, color: Color) void;
    /// Draw circle outline within an image
    pub fn drawCircleLines(self: *Image, centerX: i32, centerY: i32, radius: i32, color: Color) void {
        ImageDrawCircleLines(@ptrCast(self), centerX, centerY, radius, color);
    }

    extern fn ImageDrawCircleLinesV(dst: [*c]Image, center: Vector2, radius: c_int, color: Color) void;
    /// Draw circle outline within an image (Vector version)
    pub fn drawCircleLinesV(self: *Image, center: Vector2, radius: i32, color: Color) void {
        ImageDrawCircleLinesV(@ptrCast(self), center, radius, color);
    }

    extern fn ImageDrawRectangle(dst: [*c]Image, posX: c_int, posY: c_int, width: c_int, height: c_int, color: Color) void;
    /// Draw rectangle within an image
    pub fn drawRectangle(self: *Image, posX: i32, posY: i32, width: i32, height: i32, color: Color) void {
        ImageDrawRectangle(@ptrCast(self), posX, posY, width, height, color);
    }

    extern fn ImageDrawRectangleV(dst: [*c]Image, position: Vector2, size: Vector2, color: Color) void;
    /// Draw rectangle within an image (Vector version)
    pub fn drawRectangleV(self: *Image, position: Vector2, size: Vector2, color: Color) void {
        ImageDrawRectangleV(@ptrCast(self), position, size, color);
    }

    extern fn ImageDrawRectangleRec(dst: [*c]Image, rec: Rectangle, color: Color) void;
    /// Draw rectangle within an image
    pub fn drawRectangleRec(self: *Image, rec: Rectangle, color: Color) void {
        ImageDrawRectangleRec(@ptrCast(self), rec, color);
    }

    extern fn ImageDrawRectangleLines(dst: [*c]Image, rec: Rectangle, thick: c_int, color: Color) void;
    /// Draw rectangle lines within an image
    pub fn drawRectangleLines(self: *Image, rec: Rectangle, thick: i32, color: Color) void {
        ImageDrawRectangleLines(@ptrCast(self), rec, thick, color);
    }

    extern fn ImageDrawTriangle(dst: [*c]Image, v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void;
    /// Draw triangle within an image
    pub fn drawTriangle(dst: *Image, v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void {
        ImageDrawTriangle(@ptrCast(dst), v1, v2, v3, color);
    }

    extern fn ImageDrawTriangleEx(dst: [*c]Image, v1: Vector2, v2: Vector2, v3: Vector2, c1: Color, c2: Color, c3: Color) void;
    /// Draw triangle with interpolated colors within an image
    pub fn drawTriangleEx(dst: *Image, v1: Vector2, v2: Vector2, v3: Vector2, c1: Color, c2: Color, c3: Color) void {
        ImageDrawTriangleEx(@ptrCast(dst), v1, v2, v3, c1, c2, c3);
    }

    extern fn ImageDrawTriangleLines(dst: [*c]Image, v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void;
    /// Draw triangle outline within an image
    pub fn drawTriangleLines(dst: *Image, v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void {
        ImageDrawTriangleLines(@ptrCast(dst), v1, v2, v3, color);
    }

    extern fn ImageDrawTriangleFan(dst: [*c]Image, points: [*c]const Vector2, pointCount: c_int, color: Color) void;
    /// Draw a triangle fan defined by points within an image (first vertex is the center)
    pub fn drawTriangleFan(dst: *Image, points: []const Vector2, color: Color) void {
        ImageDrawTriangleFan(@ptrCast(dst), @ptrCast(points), @intCast(points.len), color);
    }

    extern fn ImageDrawTriangleStrip(dst: [*c]Image, points: [*c]const Vector2, pointCount: c_int, color: Color) void;
    /// Draw a triangle strip defined by points within an image
    pub fn drawTriangleStrip(dst: *Image, points: []const Vector2, color: Color) void {
        ImageDrawTriangleStrip(@ptrCast(dst), @ptrCast(points), @intCast(points.len), color);
    }

    extern fn ImageDraw(dst: [*c]Image, src: Image, srcRec: Rectangle, dstRec: Rectangle, tint: Color) void;
    /// Draw a source image within a destination image (tint applied to source)
    pub fn drawImage(self: *Image, src: Image, srcRec: Rectangle, dstRec: Rectangle, t: Color) void {
        ImageDraw(@ptrCast(self), src, srcRec, dstRec, t);
    }

    extern fn ImageDrawText(dst: [*c]Image, text: [*c]const u8, posX: c_int, posY: c_int, fontSize: c_int, color: Color) void;
    /// Draw text (using default font) within an image (destination)
    pub fn drawText(self: *Image, text: [:0]const u8, posX: i32, posY: i32, fontSize: i32, color: Color) void {
        ImageDrawText(@ptrCast(self), text, posX, posY, fontSize, color);
    }

    extern fn ImageDrawTextEx(dst: [*c]Image, font: Font, text: [*c]const u8, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void;
    /// Draw text (custom sprite font) within an image (destination)
    pub fn drawTextEx(self: *Image, font: Font, text: [:0]const u8, position: Vector2, fontSize: f32, spacing: f32, t: Color) void {
        ImageDrawTextEx(@ptrCast(self), font, text, position, fontSize, spacing, t);
    }

    extern fn ExportImage(image: Image, fileName: [*c]const u8) bool;
    /// Export image data to file, returns true on success
    pub fn toFile(self: Image, fileName: [:0]const u8) bool {
        return ExportImage(self, fileName);
    }

    extern fn ExportImageAsCode(image: Image, fileName: [*c]const u8) bool;
    /// Export image as code file defining an array of bytes, returns true on success
    pub fn toCode(self: Image, fileName: [:0]const u8) bool {
        return ExportImageAsCode(self, fileName);
    }

    extern fn ExportImageToMemory(image: Image, fileType: [*c]const u8, fileSize: [*c]c_int) [*c]u8;
    /// Export image to memory buffer
    pub fn toMemory(image: Image, fileType: []const u8) Error![]u8 {
        var len: c_int = 0;
        const ptr = ExportImageToMemory(image, @ptrCast(fileType), &len);
        if (ptr == 0) return Error.InvalidImage;
        return ptr[0..@intCast(len)];
    }

    extern fn SetWindowIcon(image: Image) void;
    /// Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
    pub fn setAsWindowIcon(self: Image) void {
        SetWindowIcon(self);
    }

    /// Load texture from image data
    pub fn toTexture(self: Image) Texture.Error!Texture {
        return Texture.initImage(self);
    }

    /// Load cubemap from image, multiple image cubemap layouts supported
    pub fn toCubemap(self: Image, layout: CubemapLayout) Texture.Error!Texture {
        return Texture.initCubemap(self, layout);
    }

    pub const Colors = struct {
        RGBA_32bit: []Color,

        extern fn LoadImageColors(image: Image) [*c]Color;
        /// Load color data from image as a Color array (RGBA - 32bit)
        pub fn init(image: Image) Image.Error!Colors {
            const ptr = LoadImageColors(image);
            if (ptr == 0) return Image.Error.InvalidImage;
            safety.load();
            return .{ .RGBA_32bit = ptr[0..@intCast(image.width * image.height)] };
        }

        extern fn UnloadImageColors(colors: [*c]Color) void;
        /// Unload color data loaded with LoadImageColors()
        pub fn deinit(colors: Colors) void {
            safety.unload();
            UnloadImageColors(@ptrCast(colors.RGBA_32bit));
        }
    };

    pub const Palette = struct {
        RGBA_32bit: []Color,

        extern fn LoadImagePalette(image: Image, maxPaletteSize: c_int, colorCount: [*c]c_int) [*c]Color;
        /// Load colors palette from image as a Color array (RGBA - 32bit)
        pub fn init(image: Image, maxPaletteSize: i32) Image.Error!Palette {
            var len: c_int = 0;
            const ptr = LoadImagePalette(image, maxPaletteSize, &len);
            if (ptr == 0) return Image.Error.InvalidImage;
            safety.load();
            return .{ .RGBA_32bit = ptr[0..@intCast(len)] };
        }

        extern fn UnloadImagePalette(colors: [*c]Color) void;
        /// Unload colors palette loaded with LoadImagePalette()
        pub fn deinit(palette: Palette) void {
            safety.unload();
            UnloadImagePalette(@ptrCast(palette.RGBA_32bit));
        }
    };
};

pub const NPatch = extern struct {
    source: Rectangle,
    left: c_int,
    top: c_int,
    right: c_int,
    bottom: c_int,
    layout: NPatch.Type,

    pub const Type = enum(c_int) {
        nine_patch = 0,
        three_patch_vertical = 1,
        three_patch_horizontal = 2,
    };
};

pub const Texture = extern struct {
    id: c_uint,
    width: c_int,
    height: c_int,
    mipmaps: c_int,
    format: PixelFormat,

    pub const Error = error{InvalidTexture};

    pub const Filter = enum(c_int) {
        point = 0,
        bilinear = 1,
        trilinear = 2,
        anisotropic_4x = 3,
        anisotropic_8x = 4,
        anisotropic_16x = 5,
    };

    pub const Wrap = enum(c_int) {
        repeat = 0,
        clamp = 1,
        mirror_repeat = 2,
        mirror_clamp = 3,
    };

    /// Check if a texture is valid (loaded in GPU)
    extern fn IsTextureValid(texture: Texture) bool;

    extern fn LoadTexture(fileName: [*c]const u8) Texture;
    /// Load texture from file into GPU memory (VRAM)
    pub fn initFile(fileName: [:0]const u8) Error!Texture {
        const texture = LoadTexture(@ptrCast(fileName));
        if (!IsTextureValid(texture)) return Error.InvalidTexture;
        safety.load();
        return texture;
    }

    extern fn LoadTextureFromImage(image: Image) Texture;
    /// Load texture from image data
    pub fn initImage(image: Image) Error!Texture {
        const texture = LoadTextureFromImage(image);
        if (!IsTextureValid(texture)) return Error.InvalidTexture;
        safety.load();
        return texture;
    }

    extern fn LoadTextureCubemap(image: Image, layout: c_int) Texture;
    /// Load cubemap from image, multiple image cubemap layouts supported
    pub fn initCubemap(image: Image, layout: CubemapLayout) Error!Texture {
        const texture = LoadTextureCubemap(image, @intFromEnum(layout));
        if (!IsTextureValid(texture)) return Error.InvalidTexture;
        safety.load();
        return texture;
    }

    extern fn UnloadTexture(texture: Texture) void;
    /// Unload texture from GPU memory (VRAM)
    pub fn deinit(self: Texture) void {
        safety.unload();
        UnloadTexture(self);
    }

    extern fn UpdateTexture(texture: Texture, pixels: ?*const anyopaque) void;
    /// Update GPU texture with new data (pixels should be able to fill texture)
    pub fn update(texture: Texture, pixels: *const anyopaque) void {
        UpdateTexture(texture, pixels);
    }

    extern fn UpdateTextureRec(texture: Texture, rec: Rectangle, pixels: ?*const anyopaque) void;
    /// Update GPU texture rectangle with new data (pixels and rec should fit in texture)
    pub fn updateRec(texture: Texture, rec: Rectangle, pixels: *const anyopaque) void {
        UpdateTextureRec(texture, rec, pixels);
    }

    extern fn GenTextureMipmaps(texture: [*c]Texture) void;
    /// Generate GPU mipmaps for a texture
    pub fn genMipmaps(texture: *Texture) void {
        GenTextureMipmaps(@ptrCast(texture));
    }

    extern fn SetTextureFilter(texture: Texture, filter: c_int) void;
    /// Set texture scaling filter mode
    pub fn setFilter(texture: Texture, filter: Texture.Filter) void {
        SetTextureFilter(texture, @intFromEnum(filter));
    }

    extern fn SetTextureWrap(texture: Texture, wrap: c_int) void;
    /// Set texture wrapping mode
    pub fn setWrap(texture: Texture, wrap: Texture.Wrap) void {
        SetTextureWrap(texture, @intFromEnum(wrap));
    }

    extern fn DrawTexture(texture: Texture, posX: c_int, posY: c_int, tint: Color) void;
    /// Draw a Texture
    pub fn draw(self: Texture, posX: i32, posY: i32, tint: Color) void {
        safety.drawingBegun();
        DrawTexture(self, posX, posY, tint);
    }

    extern fn DrawTextureV(texture: Texture, position: Vector2, tint: Color) void;
    /// Draw a Texture with position defined as Vector2
    pub fn drawV(self: Texture, position: Vector2, tint: Color) void {
        safety.drawingBegun();
        DrawTextureV(self, position, tint);
    }

    extern fn DrawTextureEx(texture: Texture, position: Vector2, rotation: f32, scale: f32, tint: Color) void;
    /// Draw a Texture with extended parameters
    pub fn drawEx(self: Texture, position: Vector2, rotation: f32, scale: f32, tint: Color) void {
        safety.drawingBegun();
        DrawTextureEx(self, position, rotation, scale, tint);
    }

    extern fn DrawTextureRec(texture: Texture, source: Rectangle, position: Vector2, tint: Color) void;
    /// Draw a part of a texture defined by a rectangle
    pub fn drawRec(self: Texture, source: Rectangle, position: Vector2, tint: Color) void {
        safety.drawingBegun();
        DrawTextureRec(self, source, position, tint);
    }

    extern fn DrawTexturePro(texture: Texture, source: Rectangle, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void;
    /// Draw a part of a texture defined by a rectangle with 'pro' parameters
    pub fn drawPro(self: Texture, source: Rectangle, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void {
        safety.drawingBegun();
        DrawTexturePro(self, source, dest, origin, rotation, tint);
    }

    extern fn DrawTextureNPatch(texture: Texture, nPatchInfo: NPatch, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void;
    /// Draws a texture (or part of it) that stretches or shrinks nicely
    pub fn drawNPatch(self: Texture, nPatchInfo: NPatch, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void {
        safety.drawingBegun();
        DrawTextureNPatch(self, nPatchInfo, dest, origin, rotation, tint);
    }
};

pub const RenderTexture = extern struct {
    id: c_uint,
    texture: Texture,
    depth: Texture,

    pub const Error = error{InvalidRenderTexture};

    /// Check if a render texture is valid (loaded in GPU)
    extern fn IsRenderTextureValid(target: RenderTexture) bool;

    extern fn LoadRenderTexture(width: c_int, height: c_int) RenderTexture;
    /// Load texture for rendering (framebuffer)
    pub fn init(width: i32, height: i32) Error!RenderTexture {
        const render_texture = LoadRenderTexture(width, height);
        if (!IsRenderTextureValid(render_texture)) return Error.InvalidRenderTexture;
        safety.load();
        return render_texture;
    }

    extern fn UnloadRenderTexture(target: RenderTexture) void;
    /// Unload render texture from GPU memory (VRAM)
    pub fn deinit(self: RenderTexture) void {
        safety.unload();
        UnloadRenderTexture(self);
    }

    extern fn BeginTextureMode(target: RenderTexture) void;
    /// Begin drawing to render texture
    pub fn begin(self: RenderTexture) void {
        BeginTextureMode(self);
    }

    extern fn EndTextureMode() void;
    /// Ends drawing to render texture
    pub fn end(_: RenderTexture) void {
        EndTextureMode();
    }
};

pub const BlendMode = enum(c_int) {
    alpha = 0,
    additive = 1,
    multiplied = 2,
    add_colors = 3,
    subtract_colors = 4,
    alpha_premultiply = 5,
    custom = 6,
    custom_separate = 7,

    extern fn BeginBlendMode(mode: c_int) void;
    /// Begin blending mode (alpha, additive, multiplied, subtract, custom)
    pub fn begin(self: BlendMode) void {
        BeginBlendMode(@intFromEnum(self));
    }

    extern fn EndBlendMode() void;
    /// End blending mode (reset to default: alpha blending)
    pub fn end() void {
        EndBlendMode();
    }
};
