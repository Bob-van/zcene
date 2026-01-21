const math = @import("math.zig");
const Vector2 = math.Vector2;
const Vector3 = math.Vector3;
const Matrix = math.Matrix;

const _r2D = @import("2D.zig");
const Color = _r2D.Color;
const Rectangle = _r2D.Rectangle;
const Texture = _r2D.Texture;

const _r3D = @import("3D.zig");
const Ray = _r3D.Ray;

pub const r2D = extern struct {
    offset: Vector2,
    target: Vector2,
    rotation: f32,
    zoom: f32,

    extern fn BeginMode2D(camera: r2D) void;
    /// Begin 2D mode with camera
    pub fn begin(self: r2D) void {
        BeginMode2D(self);
    }

    extern fn EndMode2D() void;
    /// Ends 2D mode with camera
    pub fn end(_: r2D) void {
        EndMode2D();
    }

    extern fn GetWorldToScreen2D(position: Vector2, camera: r2D) Vector2;
    /// Get the screen space position for a 2d camera world space position
    pub fn getWorldToScreen2D(self: r2D, position: Vector2) Vector2 {
        return GetWorldToScreen2D(position, self);
    }

    extern fn GetScreenToWorld2D(position: Vector2, camera: r2D) Vector2;
    /// Get the world space position for a 2d camera screen space position
    pub fn getScreenToWorld2D(self: r2D, position: Vector2) Vector2 {
        return GetScreenToWorld2D(position, self);
    }

    extern fn GetCameraMatrix2D(camera: r2D) Matrix;
    /// Get camera 2d transform matrix
    pub fn getMatrix(self: r2D) Matrix {
        return GetCameraMatrix2D(self);
    }
};

pub const r3D = extern struct {
    position: Vector3,
    target: Vector3,
    up: Vector3,
    fovy: f32,
    projection: Projection,

    pub const Mode = enum(c_int) {
        custom = 0,
        free = 1,
        orbital = 2,
        first_person = 3,
        third_person = 4,
    };

    pub const Projection = enum(c_int) {
        perspective = 0,
        orthographic = 1,
    };

    extern fn BeginMode3D(camera: r3D) void;
    /// Begin 3D mode with camera
    pub fn begin(self: r3D) void {
        BeginMode3D(self);
    }

    extern fn EndMode3D() void;
    /// Ends 3D mode and returns to default 2D orthographic mode
    pub fn end(_: r3D) void {
        EndMode3D();
    }

    extern fn UpdateCamera(camera: [*c]r3D, mode: c_int) void;
    /// Update camera position for selected mode
    pub fn update(self: *r3D, mode: Mode) void {
        UpdateCamera(self, @intFromEnum(mode));
    }

    extern fn UpdateCameraPro(camera: [*c]r3D, movement: Vector3, rotation: Vector3, zoom: f32) void;
    /// Update camera movement/rotation
    pub fn updatePro(self: *r3D, movement: Vector3, rotation: Vector3, zoom: f32) void {
        UpdateCameraPro(self, movement, rotation, zoom);
    }

    extern fn GetScreenToWorldRay(position: Vector2, camera: r3D) Ray;
    /// Get a ray trace from screen position (i.e mouse)
    pub fn getScreenToWorldRay(self: r3D, position: Vector2) Ray {
        return GetScreenToWorldRay(position, self);
    }

    extern fn GetScreenToWorldRayEx(position: Vector2, camera: r3D, width: c_int, height: c_int) Ray;
    /// Get a ray trace from screen position (i.e mouse) in a viewport
    pub fn getScreenToWorldRayEx(self: r3D, position: Vector2, width: i32, height: i32) Ray {
        return GetScreenToWorldRayEx(position, self, width, height);
    }

    extern fn GetWorldToScreen(position: Vector3, camera: r3D) Vector2;
    /// Get the screen space position for a 3d world space position
    pub fn getWorldToScreen(self: r3D, position: Vector3) Vector2 {
        return GetWorldToScreen(position, self);
    }

    extern fn GetWorldToScreenEx(position: Vector3, camera: r3D, width: c_int, height: c_int) Vector2;
    /// Get size position for a 3d world space position
    pub fn getWorldToScreenEx(self: r3D, position: Vector3, width: i32, height: i32) Vector2 {
        return GetWorldToScreenEx(position, self, width, height);
    }

    extern fn GetCameraMatrix(camera: r3D) Matrix;
    /// Get camera transform matrix (view matrix)
    pub fn getMatrix(self: r3D) Matrix {
        return GetCameraMatrix(self);
    }

    extern fn DrawBillboard(camera: r3D, texture: Texture, position: Vector3, scale: f32, tint: Color) void;
    /// Draw a billboard texture
    pub fn drawBillboard(self: r3D, texture: Texture, position: Vector3, scale: f32, tint: Color) void {
        DrawBillboard(self, texture, position, scale, tint);
    }

    extern fn DrawBillboardRec(camera: r3D, texture: Texture, source: Rectangle, position: Vector3, size: Vector2, tint: Color) void;
    /// Draw a billboard texture defined by source
    pub fn drawBillboardRec(self: r3D, texture: Texture, source: Rectangle, position: Vector3, size: Vector2, tint: Color) void {
        DrawBillboardRec(self, texture, source, position, size, tint);
    }

    extern fn DrawBillboardPro(camera: r3D, texture: Texture, source: Rectangle, position: Vector3, up: Vector3, size: Vector2, origin: Vector2, rotation: f32, tint: Color) void;
    /// Draw a billboard texture defined by source and rotation
    pub fn drawBillboardPro(self: r3D, texture: Texture, source: Rectangle, position: Vector3, up: Vector3, size: Vector2, origin: Vector2, rotation: f32, tint: Color) void {
        DrawBillboardPro(self, texture, source, position, up, size, origin, rotation, tint);
    }
};
