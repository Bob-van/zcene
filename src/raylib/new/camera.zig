const math = @import("math.zig");
const Vector2 = math.Vector2;
const Vector3 = math.Vector3;
const Matrix = math.Matrix;

const r3D = @import("3D.zig");
const Ray = r3D.Ray;

pub const CameraMode = enum(c_int) {
    custom = 0,
    free = 1,
    orbital = 2,
    first_person = 3,
    third_person = 4,
};

pub const CameraProjection = enum(c_int) {
    perspective = 0,
    orthographic = 1,
};

pub const Camera2D = extern struct {
    offset: Vector2,
    target: Vector2,
    rotation: f32,
    zoom: f32,

    extern fn BeginMode2D(camera: Camera2D) void;
    /// Begin 2D mode with camera
    pub fn begin(self: Camera2D) void {
        BeginMode2D(self);
    }

    extern fn EndMode2D() void;
    /// Ends 2D mode with camera
    pub fn end(_: Camera2D) void {
        EndMode2D();
    }

    extern fn GetWorldToScreen2D(position: Vector2, camera: Camera2D) Vector2;
    /// Get the screen space position for a 2d camera world space position
    pub fn getWorldToScreen2D(self: Camera2D, position: Vector2) Vector2 {
        return GetWorldToScreen2D(position, self);
    }

    extern fn GetScreenToWorld2D(position: Vector2, camera: Camera2D) Vector2;
    /// Get the world space position for a 2d camera screen space position
    pub fn getScreenToWorld2D(self: Camera2D, position: Vector2) Vector2 {
        return GetScreenToWorld2D(position, self);
    }

    extern fn GetCameraMatrix2D(camera: Camera2D) Matrix;
    /// Get camera 2d transform matrix
    pub fn getMatrix(self: Camera2D) Matrix {
        return GetCameraMatrix2D(self);
    }
};

pub const Camera3D = extern struct {
    position: Vector3,
    target: Vector3,
    up: Vector3,
    fovy: f32,
    projection: CameraProjection,

    extern fn BeginMode3D(camera: Camera3D) void;
    /// Begin 3D mode with camera
    pub fn begin(self: Camera3D) void {
        BeginMode3D(self);
    }

    extern fn EndMode3D() void;
    /// Ends 3D mode and returns to default 2D orthographic mode
    pub fn end(_: Camera3D) void {
        EndMode3D();
    }

    extern fn UpdateCamera(camera: [*c]Camera3D, mode: c_int) void;
    /// Update camera position for selected mode
    pub fn update(self: *Camera3D, mode: CameraMode) void {
        UpdateCamera(self, @intFromEnum(mode));
    }

    extern fn UpdateCameraPro(camera: [*c]Camera3D, movement: Vector3, rotation: Vector3, zoom: f32) void;
    /// Update camera movement/rotation
    pub fn updatePro(self: *Camera3D, movement: Vector3, rotation: Vector3, zoom: f32) void {
        UpdateCameraPro(self, movement, rotation, zoom);
    }

    extern fn GetScreenToWorldRay(position: Vector2, camera: Camera3D) Ray;
    /// Get a ray trace from screen position (i.e mouse)
    pub fn getScreenToWorldRay(self: Camera3D, position: Vector2) Ray {
        return GetScreenToWorldRay(position, self);
    }

    extern fn GetScreenToWorldRayEx(position: Vector2, camera: Camera3D, width: c_int, height: c_int) Ray;
    /// Get a ray trace from screen position (i.e mouse) in a viewport
    pub fn getScreenToWorldRayEx(self: Camera3D, position: Vector2, width: i32, height: i32) Ray {
        return GetScreenToWorldRayEx(position, self, width, height);
    }

    extern fn GetWorldToScreen(position: Vector3, camera: Camera3D) Vector2;
    /// Get the screen space position for a 3d world space position
    pub fn getWorldToScreen(self: Camera3D, position: Vector3) Vector2 {
        return GetWorldToScreen(position, self);
    }

    extern fn GetWorldToScreenEx(position: Vector3, camera: Camera3D, width: c_int, height: c_int) Vector2;
    /// Get size position for a 3d world space position
    pub fn getWorldToScreenEx(self: Camera3D, position: Vector3, width: i32, height: i32) Vector2 {
        return GetWorldToScreenEx(position, self, width, height);
    }

    extern fn GetCameraMatrix(camera: Camera3D) Matrix;
    /// Get camera transform matrix (view matrix)
    pub fn getMatrix(self: Camera3D) Matrix {
        return GetCameraMatrix(self);
    }
};
