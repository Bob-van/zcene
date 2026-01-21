const math = @import("math.zig");
const Vector2 = math.Vector2;
const Vector3 = math.Vector3;
const Matrix = math.Matrix;

const _r2D = @import("2D.zig");
const Rectangle = _r2D.Rectangle;

const _r3D = @import("3D.zig");
const Ray = _r3D.Ray;
const BoundingBox = _r3D.BoundingBox;
const Mesh = _r3D.Mesh;

pub const r2D = struct {
    /// Check collision between two rectangles
    pub fn checkRecs(rec1: Rectangle, rec2: Rectangle) bool {
        return rec1.checkCollision(rec2);
    }

    extern fn CheckCollisionCircles(center1: Vector2, radius1: f32, center2: Vector2, radius2: f32) bool;
    /// Check collision between two circles
    pub fn checkCircles(center1: Vector2, radius1: f32, center2: Vector2, radius2: f32) bool {
        return CheckCollisionCircles(center1, radius1, center2, radius2);
    }

    /// Check collision between circle and rectangle
    pub fn checkCircleRec(center: Vector2, radius: f32, rec: Rectangle) bool {
        return rec.checkCollisionCircle(center, radius);
    }

    extern fn CheckCollisionCircleLine(center: Vector2, radius: f32, p1: Vector2, p2: Vector2) bool;
    /// Check if circle collides with a line created betweeen two points [p1] and [p2]
    pub fn checkCircleLine(center: Vector2, radius: f32, p1: Vector2, p2: Vector2) bool {
        return CheckCollisionCircleLine(center, radius, p1, p2);
    }

    /// Check if point is inside rectangle
    pub fn checkPointRec(point: Vector2, rec: Rectangle) bool {
        return rec.checkCollisionPoint(point);
    }

    extern fn CheckCollisionPointCircle(point: Vector2, center: Vector2, radius: f32) bool;
    /// Check if point is inside circle
    pub fn checkPointCircle(point: Vector2, center: Vector2, radius: f32) bool {
        return CheckCollisionPointCircle(point, center, radius);
    }

    extern fn CheckCollisionPointTriangle(point: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) bool;
    /// Check if point is inside a triangle
    pub fn checkPointTriangle(point: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) bool {
        return CheckCollisionPointTriangle(point, p1, p2, p3);
    }

    extern fn CheckCollisionPointLine(point: Vector2, p1: Vector2, p2: Vector2, threshold: c_int) bool;
    /// Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
    pub fn checkPointLine(point: Vector2, p1: Vector2, p2: Vector2, threshold: i32) bool {
        return CheckCollisionPointLine(point, p1, p2, threshold);
    }

    extern fn CheckCollisionPointPoly(point: Vector2, points: [*c]const Vector2, pointCount: c_int) bool;
    /// Check if point is within a polygon described by array of vertices
    pub fn checkPointPoly(point: Vector2, points: []const Vector2) bool {
        return CheckCollisionPointPoly(point, @ptrCast(points), @intCast(points.len));
    }

    extern fn CheckCollisionLines(startPos1: Vector2, endPos1: Vector2, startPos2: Vector2, endPos2: Vector2, collisionPoint: [*c]Vector2) bool;
    /// Check the collision between two lines defined by two points each, returns collision point by reference
    pub fn checkLines(startPos1: Vector2, endPos1: Vector2, startPos2: Vector2, endPos2: Vector2, collisionPoint: *Vector2) bool {
        return CheckCollisionLines(startPos1, endPos1, startPos2, endPos2, @ptrCast(collisionPoint));
    }

    /// Get collision rectangle for two rectangles collision
    pub fn getCollisionRec(rec1: Rectangle, rec2: Rectangle) Rectangle {
        return rec1.getCollision(rec2);
    }
};
pub const r3D = struct {
    extern fn CheckCollisionSpheres(center1: Vector3, radius1: f32, center2: Vector3, radius2: f32) bool;
    /// Check collision between two spheres
    pub fn checkSpheres(center1: Vector3, radius1: f32, center2: Vector3, radius2: f32) bool {
        return CheckCollisionSpheres(center1, radius1, center2, radius2);
    }

    /// Check collision between two bounding boxes
    pub fn checkBoxes(box1: BoundingBox, box2: BoundingBox) bool {
        return box1.collisionBox(box2);
    }

    /// Check collision between box and sphere
    pub fn checkBoxSphere(box: BoundingBox, center: Vector3, radius: f32) bool {
        return box.collisionSphere(center, radius);
    }

    /// Get collision info between ray and sphere
    pub fn getRaySphere(ray: Ray, center: Vector3, radius: f32) Ray.Collision {
        return ray.collisionSphere(center, radius);
    }

    /// Get collision info between ray and box
    pub fn getRayBox(ray: Ray, box: BoundingBox) Ray.Collision {
        return ray.collisionBox(box);
    }

    /// Get collision info between ray and mesh
    pub fn getRayMesh(ray: Ray, mesh: Mesh, transform: Matrix) Ray.Collision {
        return ray.collisionMesh(mesh, transform);
    }

    /// Get collision info between ray and triangle
    pub fn getRayTriangle(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3) Ray.Collision {
        return ray.collisionTriangle(p1, p2, p3);
    }

    /// Get collision info between ray and quad
    pub fn getRayQuad(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3, p4: Vector3) Ray.Collision {
        return ray.collisionQuad(p1, p2, p3, p4);
    }
};
