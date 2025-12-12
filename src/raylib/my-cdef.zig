const old = @import("cdef.zig");
const Vector3 = old.Vector3;
const Vector4 = old.Vector4;
const Matrix = old.Matrix;
const Rectangle = old.Rectangle;

pub const math = @cImport({
    @cInclude("raymath.h");
});

pub const Vector2 = extern struct {
    x: f32,
    y: f32,

    /// Vector with components value 0.0
    pub const zero: Vector2 = .{ .x = 0, .y = 0 };

    /// Vector with components value 1.0
    pub const one: Vector2 = .{ .x = 1, .y = 1 };

    pub fn init(x: f32, y: f32) Vector2 {
        return .{ .x = x, .y = y };
    }

    /// Add two vectors (v1 + v2)
    pub fn add(self: Vector2, v: Vector2) Vector2 {
        return math.vector2Add(self, v);
    }

    /// Add vector and float value
    pub fn addValue(self: Vector2, v: f32) Vector2 {
        return math.vector2AddValue(self, v);
    }

    /// Subtract two vectors (v1 - v2)
    pub fn subtract(self: Vector2, v: Vector2) Vector2 {
        return math.vector2Subtract(self, v);
    }

    /// Subtract vector by float value
    pub fn subtractValue(self: Vector2, v: f32) Vector2 {
        return math.vector2SubtractValue(self, v);
    }

    /// Calculate vector length
    pub fn length(self: Vector2) f32 {
        return math.vector2Length(self);
    }

    /// Calculate vector square length
    pub fn lengthSqr(self: Vector2) f32 {
        return math.vector2LengthSqr(self);
    }

    /// Calculate two vectors dot product
    pub fn dotProduct(self: Vector2, v: Vector2) f32 {
        return math.vector2DotProduct(self, v);
    }

    /// Calculate distance between two vectors
    pub fn distance(self: Vector2, v: Vector2) f32 {
        return math.vector2Distance(self, v);
    }

    /// Calculate square distance between two vectors
    pub fn distanceSqr(self: Vector2, v: Vector2) f32 {
        return math.vector2DistanceSqr(self, v);
    }

    /// Calculate angle from two vectors
    pub fn angle(self: Vector2, v: Vector2) f32 {
        return math.vector2Angle(self, v);
    }

    /// Calculate angle defined by a two vectors line
    pub fn lineAngle(self: Vector2, end: Vector2) f32 {
        return math.vector2LineAngle(self, end);
    }

    /// Scale vector (multiply by value)
    pub fn scale(self: Vector2, scale_: f32) Vector2 {
        return math.vector2Scale(self, scale_);
    }

    /// Multiply vector by vector
    pub fn multiply(self: Vector2, v2: Vector2) Vector2 {
        return math.vector2Multiply(self, v2);
    }

    /// Negate vector
    pub fn negate(self: Vector2) Vector2 {
        return math.vector2Negate(self);
    }

    /// Divide vector by vector
    pub fn divide(self: Vector2, v2: Vector2) Vector2 {
        return math.vector2Divide(self, v2);
    }

    /// Normalize provided vector
    pub fn normalize(self: Vector2) Vector2 {
        return math.vector2Normalize(self);
    }

    /// Transforms a Vector2 by a given Matrix
    pub fn transform(self: Vector2, mat: Matrix) Vector2 {
        return math.vector2Transform(self, mat);
    }

    /// Calculate linear interpolation between two vectors
    pub fn lerp(self: Vector2, v2: Vector2, amount: f32) Vector2 {
        return math.vector2Lerp(self, v2, amount);
    }

    /// Calculate reflected vector to normal
    pub fn reflect(self: Vector2, normal: Vector2) Vector2 {
        return math.vector2Reflect(self, normal);
    }

    /// Get min value for each pair of components
    pub fn min(self: Vector2, v2: Vector2) Vector2 {
        return math.vector2Min(self, v2);
    }

    /// Get max value for each pair of components
    pub fn max(self: Vector2, v2: Vector2) Vector2 {
        return math.vector2Max(self, v2);
    }

    /// Rotate vector by angle
    pub fn rotate(self: Vector2, angle_: f32) Vector2 {
        return math.vector2Rotate(self, angle_);
    }

    /// Move Vector towards target
    pub fn moveTowards(self: Vector2, target: Vector2, maxDistance: f32) Vector2 {
        return math.vector2MoveTowards(self, target, maxDistance);
    }

    /// Invert the given vector
    pub fn invert(self: Vector2) Vector2 {
        return math.vector2Invert(self);
    }

    /// Clamp the components of the vector between min and max values specified by the given vectors
    pub fn clamp(self: Vector2, min_: Vector2, max_: Vector2) Vector2 {
        return math.vector2Clamp(self, min_, max_);
    }

    /// Clamp the magnitude of the vector between two min and max values
    pub fn clampValue(self: Vector2, min_: f32, max_: f32) Vector2 {
        return math.vector2ClampValue(self, min_, max_);
    }

    /// Check whether two given vectors are almost equal
    pub fn equals(self: Vector2, q: Vector2) i32 {
        return math.vector2Equals(self, q);
    }

    /// Compute the direction of a refracted ray
    /// v: normalized direction of the incoming ray
    /// n: normalized normal vector of the interface of two optical media
    /// r: ratio of the refractive index of the medium from where the ray comes
    ///    to the refractive index of the medium on the other side of the surface
    pub fn refract(self: Vector2, n: Vector2, r: f32) Vector2 {
        return math.vector2Refract(self, n, r);
    }
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

    // extern fn ColorIsEqual(col1: Color, col2: Color) bool; // using my impl!
    extern fn Fade(color: Color, alpha: f32) Color;
    extern fn ColorToInt(color: Color) c_int;
    extern fn GetColor(hexValue: c_uint) Color;
    // extern fn ColorNormalize(color: Color) Vector4; // using my impl!
    // extern fn ColorFromNormalized(normalized: Vector4) Color; // using my impl!
    extern fn ColorToHSV(color: Color) Vector3;
    extern fn ColorFromHSV(hue: f32, saturation: f32, value: f32) Color;
    extern fn ColorTint(color: Color, tint: Color) Color;
    extern fn ColorBrightness(color: Color, factor: f32) Color;
    extern fn ColorContrast(color: Color, contrast: f32) Color;
    extern fn ColorAlpha(color: Color, alpha: f32) Color;
    extern fn ColorAlphaBlend(dst: Color, src: Color, tint: Color) Color;
    extern fn ColorLerp(color1: Color, color2: Color, factor: f32) Color;

    pub fn init(r: u8, g: u8, b: u8, a: u8) Color {
        return Color{ .r = r, .g = g, .b = b, .a = a };
    }

    /// Get a Color from hexadecimal value
    pub fn fromInt(hexValue: u32) Color {
        return GetColor(hexValue);
    }

    /// Get hexadecimal value for a Color
    pub fn toInt(self: Color) i32 {
        return ColorToInt(self);
    }

    /// Get Color from normalized values [0..1]
    pub fn fromNormalized(normalized: Vector4) Color {
        return .{
            .r = @intFromFloat(normalized.x * 255),
            .g = @intFromFloat(normalized.y * 255),
            .b = @intFromFloat(normalized.z * 255),
            .a = @intFromFloat(normalized.w * 255),
        };
    }

    /// Get Color normalized as float [0..1]
    pub fn toNormalized(self: Color) Vector4 {
        return .{
            .x = self.r / 255.0,
            .y = self.g / 255.0,
            .z = self.b / 255.0,
            .w = self.a / 255.0,
        };
    }

    /// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
    pub fn fromHSV(hue: f32, saturation: f32, value: f32) Color {
        return ColorFromHSV(hue, saturation, value);
    }

    /// Get HSV values for a Color, hue [0..360], saturation/value [0..1]
    pub fn toHSV(self: Color) Vector3 {
        return ColorToHSV(self);
    }

    pub fn equal(self: Color, other: Color) bool {
        return self.r == other.r and self.g == other.g and self.b == other.b and self.a == other.a;
    }

    /// Get color with alpha applied, alpha goes from 0.0 to 1.0
    pub fn fade(self: Color, a: f32) Color {
        return Fade(self, a);
    }

    /// Get color multiplied with another color
    pub fn tint(self: Color, t: Color) Color {
        return ColorTint(self, t);
    }

    /// Get color with brightness correction, brightness factor goes from -1.0 to 1.0
    pub fn brightness(self: Color, factor: f32) Color {
        return ColorBrightness(self, factor);
    }

    /// Get color with contrast correction, contrast values between -1.0 and 1.0
    pub fn contrast(self: Color, c: f32) Color {
        return ColorContrast(self, c);
    }

    /// Get color with alpha applied, alpha goes from 0.0 to 1.0
    pub fn alpha(self: Color, a: f32) Color {
        return ColorAlpha(self, a);
    }

    pub fn alphaBlend(dst: Color, src: Color, color_tint: Color) Color {
        return ColorAlphaBlend(dst, src, color_tint);
    }

    pub fn lerp(color1: Color, color2: Color, factor: f32) Color {
        return ColorLerp(color1, color2, factor);
    }
};

pub const render = struct {
    extern fn ClearBackground(color: Color) void;
    extern fn BeginDrawing() void;
    extern fn EndDrawing() void;

    pub fn clear(color: Color) void {
        ClearBackground(color);
    }
    pub fn begin() void {
        BeginDrawing();
    }
    pub fn end() void {
        EndDrawing();
    }
};

pub const draw = struct {
    extern fn DrawPixel(posX: c_int, posY: c_int, color: Color) void;
    extern fn DrawPixelV(position: Vector2, color: Color) void;
    extern fn DrawLine(startPosX: c_int, startPosY: c_int, endPosX: c_int, endPosY: c_int, color: Color) void;
    extern fn DrawLineV(startPos: Vector2, endPos: Vector2, color: Color) void;
    extern fn DrawLineEx(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void;
    extern fn DrawLineStrip(points: [*c]const Vector2, pointCount: c_int, color: Color) void;
    extern fn DrawLineBezier(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void;
    extern fn DrawCircle(centerX: c_int, centerY: c_int, radius: f32, color: Color) void;
    extern fn DrawCircleSector(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: c_int, color: Color) void;
    extern fn DrawCircleSectorLines(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: c_int, color: Color) void;
    extern fn DrawCircleGradient(centerX: c_int, centerY: c_int, radius: f32, inner: Color, outer: Color) void;
    extern fn DrawCircleV(center: Vector2, radius: f32, color: Color) void;
    extern fn DrawCircleLines(centerX: c_int, centerY: c_int, radius: f32, color: Color) void;
    extern fn DrawCircleLinesV(center: Vector2, radius: f32, color: Color) void;
    extern fn DrawEllipse(centerX: c_int, centerY: c_int, radiusH: f32, radiusV: f32, color: Color) void;
    extern fn DrawEllipseV(center: Vector2, radiusH: f32, radiusV: f32, color: Color) void;
    extern fn DrawEllipseLines(centerX: c_int, centerY: c_int, radiusH: f32, radiusV: f32, color: Color) void;
    extern fn DrawEllipseLinesV(center: Vector2, radiusH: f32, radiusV: f32, color: Color) void;
    extern fn DrawRing(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: c_int, color: Color) void;
    extern fn DrawRingLines(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: c_int, color: Color) void;
    extern fn DrawRectangle(posX: c_int, posY: c_int, width: c_int, height: c_int, color: Color) void;
    extern fn DrawRectangleV(position: Vector2, size: Vector2, color: Color) void;
    extern fn DrawRectangleRec(rec: Rectangle, color: Color) void;
    extern fn DrawRectanglePro(rec: Rectangle, origin: Vector2, rotation: f32, color: Color) void;
    extern fn DrawRectangleGradientV(posX: c_int, posY: c_int, width: c_int, height: c_int, top: Color, bottom: Color) void;
    extern fn DrawRectangleGradientH(posX: c_int, posY: c_int, width: c_int, height: c_int, left: Color, right: Color) void;
    extern fn DrawRectangleGradientEx(rec: Rectangle, topLeft: Color, bottomLeft: Color, bottomRight: Color, topRight: Color) void;
    extern fn DrawRectangleLines(posX: c_int, posY: c_int, width: c_int, height: c_int, color: Color) void;
    extern fn DrawRectangleLinesEx(rec: Rectangle, lineThick: f32, color: Color) void;
    extern fn DrawRectangleRounded(rec: Rectangle, roundness: f32, segments: c_int, color: Color) void;
    extern fn DrawRectangleRoundedLines(rec: Rectangle, roundness: f32, segments: c_int, color: Color) void;
    extern fn DrawRectangleRoundedLinesEx(rec: Rectangle, roundness: f32, segments: c_int, lineThick: f32, color: Color) void;
    extern fn DrawTriangle(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void;
    extern fn DrawTriangleLines(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void;
    extern fn DrawTriangleFan(points: [*c]const Vector2, pointCount: c_int, color: Color) void;
    extern fn DrawTriangleStrip(points: [*c]const Vector2, pointCount: c_int, color: Color) void;
    extern fn DrawPoly(center: Vector2, sides: c_int, radius: f32, rotation: f32, color: Color) void;
    extern fn DrawPolyLines(center: Vector2, sides: c_int, radius: f32, rotation: f32, color: Color) void;
    extern fn DrawPolyLinesEx(center: Vector2, sides: c_int, radius: f32, rotation: f32, lineThick: f32, color: Color) void;
    extern fn DrawSplineLinear(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    extern fn DrawSplineBasis(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    extern fn DrawSplineCatmullRom(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    extern fn DrawSplineBezierQuadratic(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    extern fn DrawSplineBezierCubic(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    extern fn DrawSplineSegmentLinear(p1: Vector2, p2: Vector2, thick: f32, color: Color) void;
    extern fn DrawSplineSegmentBasis(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: f32, color: Color) void;
    extern fn DrawSplineSegmentCatmullRom(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: f32, color: Color) void;
    extern fn DrawSplineSegmentBezierQuadratic(p1: Vector2, c2: Vector2, p3: Vector2, thick: f32, color: Color) void;
    extern fn DrawSplineSegmentBezierCubic(p1: Vector2, c2: Vector2, c3: Vector2, p4: Vector2, thick: f32, color: Color) void;
};
