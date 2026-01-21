const safety = @import("safety.zig");

const frame = @import("frame.zig");

const math = @import("math.zig");
const Vector2 = math.Vector2;
const Vector3 = math.Vector3;

const _r2D = @import("2D.zig");
const Color = _r2D.Color;
const Rectangle = _r2D.Rectangle;
const Texture = _r2D.Texture;

extern fn ClearBackground(color: Color) void;
/// Set background color (framebuffer clear color)
pub fn clear(color: Color) void {
    safety.drawingBegun();
    ClearBackground(color);
}

extern fn BeginScissorMode(x: c_int, y: c_int, width: c_int, height: c_int) void;
/// Begin scissor mode (define screen area for following drawing)
pub fn beginScissorMode(x: i32, y: i32, width: i32, height: i32) void {
    BeginScissorMode(x, y, width, height);
}

extern fn EndScissorMode() void;
/// End scissor mode
pub fn endScissorMode() void {
    EndScissorMode();
}

pub const r2D = struct {
    /// Set texture and rectangle to be used on shapes drawing
    ///
    /// NOTE: It can be useful when using basic shapes and one single font,
    ///
    /// defining a font char white rectangle would allow drawing everything in a single draw call
    pub const batching = struct {
        extern fn SetShapesTexture(texture: Texture, source: Rectangle) void;
        /// Set texture and rectangle to be used on shapes drawing
        pub fn set(texture: Texture, source: Rectangle) void {
            SetShapesTexture(texture, source);
        }

        extern fn GetShapesTexture() Texture;
        /// Get texture that is used for shapes drawing
        pub fn getTexture() Texture {
            return GetShapesTexture();
        }

        extern fn GetShapesTextureRectangle() Rectangle;
        /// Get texture source rectangle that is used for shapes drawing
        pub fn getRectangle() Rectangle {
            return GetShapesTextureRectangle();
        }
    };

    extern fn DrawPixel(posX: c_int, posY: c_int, color: Color) void;
    /// Draw a pixel using geometry [Can be slow, use with care]
    pub fn pixel(posX: i32, posY: i32, color: Color) void {
        safety.drawingBegun();
        DrawPixel(posX, posY, color);
    }

    extern fn DrawPixelV(position: Vector2, color: Color) void;
    /// Draw a pixel using geometry (Vector version) [Can be slow, use with care]
    pub fn pixelV(position: Vector2, color: Color) void {
        safety.drawingBegun();
        DrawPixelV(position, color);
    }

    extern fn DrawLine(startPosX: c_int, startPosY: c_int, endPosX: c_int, endPosY: c_int, color: Color) void;
    /// Draw a line
    pub fn line(startPosX: i32, startPosY: i32, endPosX: i32, endPosY: i32, color: Color) void {
        safety.drawingBegun();
        DrawLine(startPosX, startPosY, endPosX, endPosY, color);
    }

    extern fn DrawLineV(startPos: Vector2, endPos: Vector2, color: Color) void;
    /// Draw a line (using gl lines)
    pub fn lineV(startPos: Vector2, endPos: Vector2, color: Color) void {
        safety.drawingBegun();
        DrawLineV(startPos, endPos, color);
    }

    extern fn DrawLineEx(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void;
    /// Draw a line (using triangles/quads)
    pub fn lineEx(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawLineEx(startPos, endPos, thick, color);
    }

    extern fn DrawLineStrip(points: [*c]const Vector2, pointCount: c_int, color: Color) void;
    /// Draw lines sequence (using gl lines)
    pub fn lineStrip(points: []const Vector2, color: Color) void {
        safety.drawingBegun();
        DrawLineStrip(@ptrCast(points), @intCast(points.len), color);
    }

    extern fn DrawLineBezier(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void;
    /// Draw line segment cubic-bezier in-out interpolation
    pub fn lineBezier(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawLineBezier(startPos, endPos, thick, color);
    }

    extern fn DrawCircle(centerX: c_int, centerY: c_int, radius: f32, color: Color) void;
    /// Draw a color-filled circle
    pub fn circle(centerX: i32, centerY: i32, radius: f32, color: Color) void {
        safety.drawingBegun();
        DrawCircle(centerX, centerY, radius, color);
    }

    extern fn DrawCircleSector(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: c_int, color: Color) void;
    /// Draw a piece of a circle
    pub fn circleSector(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void {
        safety.drawingBegun();
        DrawCircleSector(center, radius, startAngle, endAngle, segments, color);
    }

    extern fn DrawCircleSectorLines(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: c_int, color: Color) void;
    /// Draw circle sector outline
    pub fn circleSectorLines(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void {
        safety.drawingBegun();
        DrawCircleSectorLines(center, radius, startAngle, endAngle, segments, color);
    }

    extern fn DrawCircleGradient(centerX: c_int, centerY: c_int, radius: f32, inner: Color, outer: Color) void;
    /// Draw a gradient-filled circle
    pub fn circleGradient(centerX: i32, centerY: i32, radius: f32, inner: Color, outer: Color) void {
        safety.drawingBegun();
        DrawCircleGradient(centerX, centerY, radius, inner, outer);
    }

    extern fn DrawCircleV(center: Vector2, radius: f32, color: Color) void;
    /// Draw a color-filled circle (Vector version)
    pub fn circleV(center: Vector2, radius: f32, color: Color) void {
        safety.drawingBegun();
        DrawCircleV(center, radius, color);
    }

    extern fn DrawCircleLines(centerX: c_int, centerY: c_int, radius: f32, color: Color) void;
    /// Draw circle outline
    pub fn circleLines(centerX: i32, centerY: i32, radius: f32, color: Color) void {
        safety.drawingBegun();
        DrawCircleLines(centerX, centerY, radius, color);
    }

    extern fn DrawCircleLinesV(center: Vector2, radius: f32, color: Color) void;
    /// Draw circle outline (Vector version)
    pub fn circleLinesV(center: Vector2, radius: f32, color: Color) void {
        safety.drawingBegun();
        DrawCircleLinesV(center, radius, color);
    }

    extern fn DrawEllipse(centerX: c_int, centerY: c_int, radiusH: f32, radiusV: f32, color: Color) void;
    /// Draw ellipse
    pub fn ellipse(centerX: i32, centerY: i32, radiusH: f32, radiusV: f32, color: Color) void {
        safety.drawingBegun();
        DrawEllipse(centerX, centerY, radiusH, radiusV, color);
    }

    extern fn DrawEllipseV(center: Vector2, radiusH: f32, radiusV: f32, color: Color) void;
    /// Draw ellipse (Vector version)
    pub fn ellipseV(center: Vector2, radiusH: f32, radiusV: f32, color: Color) void {
        safety.drawingBegun();
        DrawEllipseV(center, radiusH, radiusV, color);
    }

    extern fn DrawEllipseLines(centerX: c_int, centerY: c_int, radiusH: f32, radiusV: f32, color: Color) void;
    /// Draw ellipse outline
    pub fn ellipseLines(centerX: i32, centerY: i32, radiusH: f32, radiusV: f32, color: Color) void {
        safety.drawingBegun();
        DrawEllipseLines(centerX, centerY, radiusH, radiusV, color);
    }

    extern fn DrawEllipseLinesV(center: Vector2, radiusH: f32, radiusV: f32, color: Color) void;
    /// Draw ellipse outline (Vector version)
    pub fn ellipseLinesV(center: Vector2, radiusH: f32, radiusV: f32, color: Color) void {
        safety.drawingBegun();
        DrawEllipseLinesV(center, radiusH, radiusV, color);
    }

    extern fn DrawRing(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: c_int, color: Color) void;
    /// Draw ring
    pub fn ring(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void {
        safety.drawingBegun();
        DrawRing(center, innerRadius, outerRadius, startAngle, endAngle, segments, color);
    }

    extern fn DrawRingLines(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: c_int, color: Color) void;
    /// Draw ring outline
    pub fn ringLines(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void {
        safety.drawingBegun();
        DrawRingLines(center, innerRadius, outerRadius, startAngle, endAngle, segments, color);
    }

    extern fn DrawRectangle(posX: c_int, posY: c_int, width: c_int, height: c_int, color: Color) void;
    /// Draw a color-filled rectangle
    pub fn rectangle(posX: i32, posY: i32, width: i32, height: i32, color: Color) void {
        safety.drawingBegun();
        DrawRectangle(posX, posY, width, height, color);
    }

    extern fn DrawRectangleV(position: Vector2, size: Vector2, color: Color) void;
    /// Draw a color-filled rectangle (Vector version)
    pub fn rectangleV(position: Vector2, size: Vector2, color: Color) void {
        safety.drawingBegun();
        DrawRectangleV(position, size, color);
    }

    /// Draw a color-filled rectangle
    pub fn rectangleRec(rec: Rectangle, color: Color) void {
        Rectangle.draw(rec, color);
    }

    /// Draw a color-filled rectangle with pro parameters
    pub fn rectanglePro(rec: Rectangle, origin: Vector2, rotation: f32, color: Color) void {
        Rectangle.drawPro(rec, origin, rotation, color);
    }

    extern fn DrawRectangleGradientV(posX: c_int, posY: c_int, width: c_int, height: c_int, top: Color, bottom: Color) void;
    /// Draw a vertical-gradient-filled rectangle
    pub fn rectangleGradientV(posX: i32, posY: i32, width: i32, height: i32, top: Color, bottom: Color) void {
        safety.drawingBegun();
        DrawRectangleGradientV(posX, posY, width, height, top, bottom);
    }

    extern fn DrawRectangleGradientH(posX: c_int, posY: c_int, width: c_int, height: c_int, left: Color, right: Color) void;
    /// Draw a horizontal-gradient-filled rectangle
    pub fn rectangleGradientH(posX: i32, posY: i32, width: i32, height: i32, left: Color, right: Color) void {
        safety.drawingBegun();
        DrawRectangleGradientH(posX, posY, width, height, left, right);
    }

    /// Draw a gradient-filled rectangle with custom vertex colors
    pub fn rectangleGradientEx(rec: Rectangle, topLeft: Color, bottomLeft: Color, bottomRight: Color, topRight: Color) void {
        Rectangle.drawGradientEx(rec, topLeft, bottomLeft, bottomRight, topRight);
    }

    extern fn DrawRectangleLines(posX: c_int, posY: c_int, width: c_int, height: c_int, color: Color) void;
    /// Draw rectangle outline
    pub fn rectangleLines(posX: i32, posY: i32, width: i32, height: i32, color: Color) void {
        safety.drawingBegun();
        DrawRectangleLines(posX, posY, width, height, color);
    }

    /// Draw rectangle outline with extended parameters
    pub fn rectangleLinesEx(rec: Rectangle, lineThick: f32, color: Color) void {
        Rectangle.drawLinesEx(rec, lineThick, color);
    }

    /// Draw rectangle with rounded edges
    pub fn rectangleRounded(rec: Rectangle, roundness: f32, segments: i32, color: Color) void {
        Rectangle.drawRounded(rec, roundness, segments, color);
    }

    /// Draw rectangle lines with rounded edges
    pub fn rectangleRoundedLines(rec: Rectangle, roundness: f32, segments: i32, color: Color) void {
        Rectangle.drawRoundedLines(rec, roundness, segments, color);
    }

    /// Draw rectangle with rounded edges outline
    pub fn rectangleRoundedLinesEx(rec: Rectangle, roundness: f32, segments: i32, lineThick: f32, color: Color) void {
        Rectangle.drawRoundedLinesEx(rec, roundness, segments, lineThick, color);
    }

    extern fn DrawTriangle(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void;
    /// Draw a color-filled triangle (vertex in counter-clockwise order!)
    pub fn triangle(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void {
        safety.drawingBegun();
        DrawTriangle(v1, v2, v3, color);
    }

    extern fn DrawTriangleLines(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void;
    /// Draw triangle outline (vertex in counter-clockwise order!)
    pub fn triangleLines(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void {
        safety.drawingBegun();
        DrawTriangleLines(v1, v2, v3, color);
    }

    extern fn DrawTriangleFan(points: [*c]const Vector2, pointCount: c_int, color: Color) void;
    /// Draw a triangle fan defined by points (first vertex is the center)
    pub fn triangleFan(points: []const Vector2, color: Color) void {
        safety.drawingBegun();
        DrawTriangleFan(@ptrCast(points), @intCast(points.len), color);
    }

    extern fn DrawTriangleStrip(points: [*c]const Vector2, pointCount: c_int, color: Color) void;
    /// Draw a triangle strip defined by points
    pub fn triangleStrip(points: []const Vector2, color: Color) void {
        safety.drawingBegun();
        DrawTriangleStrip(@ptrCast(points), @intCast(points.len), color);
    }

    extern fn DrawPoly(center: Vector2, sides: c_int, radius: f32, rotation: f32, color: Color) void;
    /// Draw a regular polygon (Vector version)
    pub fn poly(center: Vector2, sides: i32, radius: f32, rotation: f32, color: Color) void {
        safety.drawingBegun();
        DrawPoly(center, sides, radius, rotation, color);
    }

    extern fn DrawPolyLines(center: Vector2, sides: c_int, radius: f32, rotation: f32, color: Color) void;
    /// Draw a polygon outline of n sides
    pub fn polyLines(center: Vector2, sides: i32, radius: f32, rotation: f32, color: Color) void {
        safety.drawingBegun();
        DrawPolyLines(center, sides, radius, rotation, color);
    }

    extern fn DrawPolyLinesEx(center: Vector2, sides: c_int, radius: f32, rotation: f32, lineThick: f32, color: Color) void;
    /// Draw a polygon outline of n sides with extended parameters
    pub fn polyLinesEx(center: Vector2, sides: i32, radius: f32, rotation: f32, lineThick: f32, color: Color) void {
        safety.drawingBegun();
        DrawPolyLinesEx(center, sides, radius, rotation, lineThick, color);
    }

    extern fn DrawSplineLinear(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    /// Draw spline: Linear, minimum 2 points
    pub fn splineLinear(points: []const Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineLinear(@ptrCast(points), @intCast(points.len), thick, color);
    }

    extern fn DrawSplineBasis(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    /// Draw spline: B-Spline, minimum 4 points
    pub fn splineBasis(points: []const Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineBasis(@ptrCast(points), @intCast(points.len), thick, color);
    }

    extern fn DrawSplineCatmullRom(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    /// Draw spline: Catmull-Rom, minimum 4 points
    pub fn splineCatmullRom(points: []const Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineCatmullRom(@ptrCast(points), @intCast(points.len), thick, color);
    }

    extern fn DrawSplineBezierQuadratic(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    /// Draw spline: Quadratic Bezier, minimum 3 points (1 control point): [p1, c2, p3, c4...]
    pub fn splineBezierQuadratic(points: []const Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineBezierQuadratic(@ptrCast(points), @intCast(points.len), thick, color);
    }

    extern fn DrawSplineBezierCubic(points: [*c]const Vector2, pointCount: c_int, thick: f32, color: Color) void;
    /// Draw spline: Cubic Bezier, minimum 4 points (2 control points): [p1, c2, c3, p4, c5, c6...]
    pub fn splineBezierCubic(points: []const Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineBezierCubic(@ptrCast(points), @intCast(points.len), thick, color);
    }

    extern fn DrawSplineSegmentLinear(p1: Vector2, p2: Vector2, thick: f32, color: Color) void;
    /// Draw spline segment: Linear, 2 points
    pub fn splineSegmentLinear(p1: Vector2, p2: Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineSegmentLinear(p1, p2, thick, color);
    }

    extern fn DrawSplineSegmentBasis(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: f32, color: Color) void;
    /// Draw spline segment: B-Spline, 4 points
    pub fn splineSegmentBasis(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineSegmentBasis(p1, p2, p3, p4, thick, color);
    }

    extern fn DrawSplineSegmentCatmullRom(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: f32, color: Color) void;
    /// Draw spline segment: Catmull-Rom, 4 points
    pub fn splineSegmentCatmullRom(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineSegmentCatmullRom(p1, p2, p3, p4, thick, color);
    }

    extern fn DrawSplineSegmentBezierQuadratic(p1: Vector2, c2: Vector2, p3: Vector2, thick: f32, color: Color) void;
    /// Draw spline segment: Quadratic Bezier, 2 points, 1 control point
    pub fn splineSegmentBezierQuadratic(p1: Vector2, c2: Vector2, p3: Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineSegmentBezierQuadratic(p1, c2, p3, thick, color);
    }

    extern fn DrawSplineSegmentBezierCubic(p1: Vector2, c2: Vector2, c3: Vector2, p4: Vector2, thick: f32, color: Color) void;
    /// Draw spline segment: Cubic Bezier, 2 points, 2 control points
    pub fn splineSegmentBezierCubic(p1: Vector2, c2: Vector2, c3: Vector2, p4: Vector2, thick: f32, color: Color) void {
        safety.drawingBegun();
        DrawSplineSegmentBezierCubic(p1, c2, c3, p4, thick, color);
    }
};

pub const r3D = struct {
    extern fn DrawLine3D(startPos: Vector3, endPos: Vector3, color: Color) void;
    /// Draw a line in 3D world space
    pub fn line(startPos: Vector3, endPos: Vector3, color: Color) void {
        safety.drawingBegun();
        DrawLine3D(startPos, endPos, color);
    }

    extern fn DrawPoint3D(position: Vector3, color: Color) void;
    /// Draw a point in 3D space, actually a small line
    pub fn point(position: Vector3, color: Color) void {
        safety.drawingBegun();
        DrawPoint3D(position, color);
    }

    extern fn DrawCircle3D(center: Vector3, radius: f32, rotationAxis: Vector3, rotationAngle: f32, color: Color) void;
    /// Draw a circle in 3D world space
    pub fn circle(center: Vector3, radius: f32, rotationAxis: Vector3, rotationAngle: f32, color: Color) void {
        safety.drawingBegun();
        DrawCircle3D(center, radius, rotationAxis, rotationAngle, color);
    }

    extern fn DrawTriangle3D(v1: Vector3, v2: Vector3, v3: Vector3, color: Color) void;
    /// Draw a color-filled triangle (vertex in counter-clockwise order!)
    pub fn triangle(v1: Vector3, v2: Vector3, v3: Vector3, color: Color) void {
        safety.drawingBegun();
        DrawTriangle3D(v1, v2, v3, color);
    }

    extern fn DrawTriangleStrip3D(points: [*c]const Vector3, pointCount: c_int, color: Color) void;
    /// Draw a triangle strip defined by points
    pub fn triangleStrip(points: []const Vector3, color: Color) void {
        safety.drawingBegun();
        DrawTriangleStrip3D(@ptrCast(points), @intCast(points.len), color);
    }

    extern fn DrawCube(position: Vector3, width: f32, height: f32, length: f32, color: Color) void;
    /// Draw cube
    pub fn cube(position: Vector3, width: f32, height: f32, length: f32, color: Color) void {
        safety.drawingBegun();
        DrawCube(position, width, height, length, color);
    }

    extern fn DrawCubeV(position: Vector3, size: Vector3, color: Color) void;
    /// Draw cube (Vector version)
    pub fn cubeV(position: Vector3, size: Vector3, color: Color) void {
        safety.drawingBegun();
        DrawCubeV(position, size, color);
    }

    extern fn DrawCubeWires(position: Vector3, width: f32, height: f32, length: f32, color: Color) void;
    /// Draw cube wires
    pub fn cubeWires(position: Vector3, width: f32, height: f32, length: f32, color: Color) void {
        safety.drawingBegun();
        DrawCubeWires(position, width, height, length, color);
    }

    extern fn DrawCubeWiresV(position: Vector3, size: Vector3, color: Color) void;
    /// Draw cube wires (Vector version)
    pub fn cubeWiresV(position: Vector3, size: Vector3, color: Color) void {
        safety.drawingBegun();
        DrawCubeWiresV(position, size, color);
    }

    extern fn DrawSphere(centerPos: Vector3, radius: f32, color: Color) void;
    /// Draw sphere
    pub fn sphere(centerPos: Vector3, radius: f32, color: Color) void {
        safety.drawingBegun();
        DrawSphere(centerPos, radius, color);
    }

    extern fn DrawSphereEx(centerPos: Vector3, radius: f32, rings: c_int, slices: c_int, color: Color) void;
    /// Draw sphere with extended parameters
    pub fn sphereEx(centerPos: Vector3, radius: f32, rings: i32, slices: i32, color: Color) void {
        safety.drawingBegun();
        DrawSphereEx(centerPos, radius, rings, slices, color);
    }

    extern fn DrawSphereWires(centerPos: Vector3, radius: f32, rings: c_int, slices: c_int, color: Color) void;
    /// Draw sphere wires
    pub fn sphereWires(centerPos: Vector3, radius: f32, rings: i32, slices: i32, color: Color) void {
        safety.drawingBegun();
        DrawSphereWires(centerPos, radius, rings, slices, color);
    }

    extern fn DrawCylinder(position: Vector3, radiusTop: f32, radiusBottom: f32, height: f32, slices: c_int, color: Color) void;
    /// Draw a cylinder/cone
    pub fn cylinder(position: Vector3, radiusTop: f32, radiusBottom: f32, height: f32, slices: i32, color: Color) void {
        safety.drawingBegun();
        DrawCylinder(position, radiusTop, radiusBottom, height, slices, color);
    }

    extern fn DrawCylinderEx(startPos: Vector3, endPos: Vector3, startRadius: f32, endRadius: f32, sides: c_int, color: Color) void;
    /// Draw a cylinder with base at startPos and top at endPos
    pub fn cylinderEx(startPos: Vector3, endPos: Vector3, startRadius: f32, endRadius: f32, sides: i32, color: Color) void {
        safety.drawingBegun();
        DrawCylinderEx(startPos, endPos, startRadius, endRadius, sides, color);
    }

    extern fn DrawCylinderWires(position: Vector3, radiusTop: f32, radiusBottom: f32, height: f32, slices: c_int, color: Color) void;
    /// Draw a cylinder/cone wires
    pub fn cylinderWires(position: Vector3, radiusTop: f32, radiusBottom: f32, height: f32, slices: i32, color: Color) void {
        safety.drawingBegun();
        DrawCylinderWires(position, radiusTop, radiusBottom, height, slices, color);
    }

    extern fn DrawCylinderWiresEx(startPos: Vector3, endPos: Vector3, startRadius: f32, endRadius: f32, sides: c_int, color: Color) void;
    /// Draw a cylinder wires with base at startPos and top at endPos
    pub fn cylinderWiresEx(startPos: Vector3, endPos: Vector3, startRadius: f32, endRadius: f32, sides: i32, color: Color) void {
        safety.drawingBegun();
        DrawCylinderWiresEx(startPos, endPos, startRadius, endRadius, sides, color);
    }

    extern fn DrawCapsule(startPos: Vector3, endPos: Vector3, radius: f32, slices: c_int, rings: c_int, color: Color) void;
    /// Draw a capsule with the center of its sphere caps at startPos and endPos
    pub fn capsule(startPos: Vector3, endPos: Vector3, radius: f32, slices: i32, rings: i32, color: Color) void {
        safety.drawingBegun();
        DrawCapsule(startPos, endPos, radius, slices, rings, color);
    }

    extern fn DrawCapsuleWires(startPos: Vector3, endPos: Vector3, radius: f32, slices: c_int, rings: c_int, color: Color) void;
    /// Draw capsule wireframe with the center of its sphere caps at startPos and endPos
    pub fn capsuleWires(startPos: Vector3, endPos: Vector3, radius: f32, slices: i32, rings: i32, color: Color) void {
        safety.drawingBegun();
        DrawCapsuleWires(startPos, endPos, radius, slices, rings, color);
    }

    extern fn DrawPlane(centerPos: Vector3, size: Vector2, color: Color) void;
    /// Draw a plane XZ
    pub fn plane(centerPos: Vector3, size: Vector2, color: Color) void {
        safety.drawingBegun();
        DrawPlane(centerPos, size, color);
    }

    extern fn DrawGrid(slices: c_int, spacing: f32) void;
    /// Draw a grid (centered at (0, 0, 0))
    pub fn grid(slices: i32, spacing: f32) void {
        safety.drawingBegun();
        DrawGrid(slices, spacing);
    }
};
