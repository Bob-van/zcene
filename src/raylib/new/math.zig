const math = @import("raymath.zig");

pub const Vector2 = extern struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vector2 {
        return Vector2{ .x = x, .y = y };
    }

    extern fn GetSplinePointLinear(startPos: Vector2, endPos: Vector2, t: f32) Vector2;
    /// Get (evaluate) spline point: Linear
    pub fn initSplinePointLinear(startPos: Vector2, endPos: Vector2, t: f32) Vector2 {
        return GetSplinePointLinear(startPos, endPos, t);
    }

    extern fn GetSplinePointBasis(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, t: f32) Vector2;
    /// Get (evaluate) spline point: B-Spline
    pub fn initSplinePointBasis(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, t: f32) Vector2 {
        return GetSplinePointBasis(p1, p2, p3, p4, t);
    }

    extern fn GetSplinePointCatmullRom(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, t: f32) Vector2;
    /// Get (evaluate) spline point: Catmull-Rom
    pub fn initSplinePointCatmullRom(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, t: f32) Vector2 {
        return GetSplinePointCatmullRom(p1, p2, p3, p4, t);
    }

    extern fn GetSplinePointBezierQuad(p1: Vector2, c2: Vector2, p3: Vector2, t: f32) Vector2;
    /// Get (evaluate) spline point: Quadratic Bezier
    pub fn initSplinePointBezierQuad(p1: Vector2, c2: Vector2, p3: Vector2, t: f32) Vector2 {
        return GetSplinePointBezierQuad(p1, c2, p3, t);
    }

    extern fn GetSplinePointBezierCubic(p1: Vector2, c2: Vector2, c3: Vector2, p4: Vector2, t: f32) Vector2;
    /// Get (evaluate) spline point: Cubic Bezier
    pub fn initSplinePointBezierCubic(p1: Vector2, c2: Vector2, c3: Vector2, p4: Vector2, t: f32) Vector2 {
        return GetSplinePointBezierCubic(p1, c2, c3, p4, t);
    }

    /// Vector with components value 0.0
    pub fn zero() Vector2 {
        return math.Vector2Zero();
    }

    /// Vector with components value 1.0
    pub fn one() Vector2 {
        return math.Vector2One();
    }

    /// Add two vectors (v1 + v2)
    pub fn add(self: Vector2, v: Vector2) Vector2 {
        return math.Vector2Add(self, v);
    }

    /// Add vector and float value
    pub fn addValue(self: Vector2, v: f32) Vector2 {
        return math.Vector2AddValue(self, v);
    }

    /// Subtract two vectors (v1 - v2)
    pub fn subtract(self: Vector2, v: Vector2) Vector2 {
        return math.Vector2Subtract(self, v);
    }

    /// Subtract vector by float value
    pub fn subtractValue(self: Vector2, v: f32) Vector2 {
        return math.Vector2SubtractValue(self, v);
    }

    /// Calculate vector length
    pub fn length(self: Vector2) f32 {
        return math.Vector2Length(self);
    }

    /// Calculate vector square length
    pub fn lengthSqr(self: Vector2) f32 {
        return math.Vector2LengthSqr(self);
    }

    /// Calculate two vectors dot product
    pub fn dotProduct(self: Vector2, v: Vector2) f32 {
        return math.Vector2DotProduct(self, v);
    }

    /// Calculate distance between two vectors
    pub fn distance(self: Vector2, v: Vector2) f32 {
        return math.Vector2Distance(self, v);
    }

    /// Calculate square distance between two vectors
    pub fn distanceSqr(self: Vector2, v: Vector2) f32 {
        return math.Vector2DistanceSqr(self, v);
    }

    /// Calculate angle from two vectors
    pub fn angle(self: Vector2, v: Vector2) f32 {
        return math.Vector2Angle(self, v);
    }

    /// Calculate angle defined by a two vectors line
    pub fn lineAngle(self: Vector2, end: Vector2) f32 {
        return math.Vector2LineAngle(self, end);
    }

    /// Scale vector (multiply by value)
    pub fn scale(self: Vector2, scale_: f32) Vector2 {
        return math.Vector2Scale(self, scale_);
    }

    /// Multiply vector by vector
    pub fn multiply(self: Vector2, v2: Vector2) Vector2 {
        return math.Vector2Multiply(self, v2);
    }

    /// Negate vector
    pub fn negate(self: Vector2) Vector2 {
        return math.Vector2Negate(self);
    }

    /// Divide vector by vector
    pub fn divide(self: Vector2, v2: Vector2) Vector2 {
        return math.Vector2Divide(self, v2);
    }

    /// Normalize provided vector
    pub fn normalize(self: Vector2) Vector2 {
        return math.Vector2Normalize(self);
    }

    /// Transforms a Vector2 by a given Matrix
    pub fn transform(self: Vector2, mat: Matrix) Vector2 {
        return math.Vector2Transform(self, mat);
    }

    /// Calculate linear interpolation between two vectors
    pub fn lerp(self: Vector2, v2: Vector2, amount: f32) Vector2 {
        return math.Vector2Lerp(self, v2, amount);
    }

    /// Calculate reflected vector to normal
    pub fn reflect(self: Vector2, normal: Vector2) Vector2 {
        return math.Vector2Reflect(self, normal);
    }

    /// Get min value for each pair of components
    pub fn min(self: Vector2, v2: Vector2) Vector2 {
        return math.Vector2Min(self, v2);
    }

    /// Get max value for each pair of components
    pub fn max(self: Vector2, v2: Vector2) Vector2 {
        return math.Vector2Max(self, v2);
    }

    /// Rotate vector by angle
    pub fn rotate(self: Vector2, angle_: f32) Vector2 {
        return math.Vector2Rotate(self, angle_);
    }

    /// Move Vector towards target
    pub fn moveTowards(self: Vector2, target: Vector2, maxDistance: f32) Vector2 {
        return math.Vector2MoveTowards(self, target, maxDistance);
    }

    /// Invert the given vector
    pub fn invert(self: Vector2) Vector2 {
        return math.Vector2Invert(self);
    }

    /// Clamp the components of the vector between min and max values specified by the given vectors
    pub fn clamp(self: Vector2, min_: Vector2, max_: Vector2) Vector2 {
        return math.Vector2Clamp(self, min_, max_);
    }

    /// Clamp the magnitude of the vector between two min and max values
    pub fn clampValue(self: Vector2, min_: f32, max_: f32) Vector2 {
        return math.Vector2ClampValue(self, min_, max_);
    }

    /// Check whether two given vectors are almost equal
    pub fn equals(self: Vector2, q: Vector2) i32 {
        return math.Vector2Equals(self, q);
    }

    /// Compute the direction of a refracted ray
    /// v: normalized direction of the incoming ray
    /// n: normalized normal vector of the interface of two optical media
    /// r: ratio of the refractive index of the medium from where the ray comes
    ///    to the refractive index of the medium on the other side of the surface
    pub fn refract(self: Vector2, n: Vector2, r: f32) Vector2 {
        return math.Vector2Refract(self, n, r);
    }
};

pub const Vector3 = extern struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vector3 {
        return Vector3{ .x = x, .y = y, .z = z };
    }

    // Vector with components value 0.0
    pub fn zero() Vector3 {
        return math.Vector3Zero();
    }

    /// Vector with components value 1.0
    pub fn one() Vector3 {
        return math.Vector3One();
    }

    /// Add two vectors
    pub fn add(self: Vector3, v: Vector3) Vector3 {
        return math.Vector3Add(self, v);
    }

    /// Add vector and float value
    pub fn addValue(self: Vector3, add_: f32) Vector3 {
        return math.Vector3AddValue(self, add_);
    }

    /// Subtract two vectors
    pub fn subtract(self: Vector3, v: Vector3) Vector3 {
        return math.Vector3Subtract(self, v);
    }

    /// Subtract vector by float value
    pub fn subtractValue(self: Vector3, sub: f32) Vector3 {
        return math.Vector3SubtractValue(self, sub);
    }

    /// Multiply vector by scalar
    pub fn scale(self: Vector3, scalar: f32) Vector3 {
        return math.Vector3Scale(self, scalar);
    }

    /// Multiply vector by vector
    pub fn multiply(self: Vector3, v: Vector3) Vector3 {
        return math.Vector3Multiply(self, v);
    }

    /// Calculate two vectors cross product
    pub fn crossProduct(self: Vector3, v: Vector3) Vector3 {
        return math.Vector3CrossProduct(self, v);
    }

    /// Calculate one vector perpendicular vector
    pub fn perpendicular(self: Vector3) Vector3 {
        return math.Vector3Perpendicular(self);
    }

    /// Calculate vector length
    pub fn length(self: Vector3) f32 {
        return math.Vector3Length(self);
    }

    /// Calculate vector square length
    pub fn lengthSqr(self: Vector3) f32 {
        return math.Vector3LengthSqr(self);
    }

    /// Calculate two vectors dot product
    pub fn dotProduct(self: Vector3, v: Vector3) f32 {
        return math.Vector3DotProduct(self, v);
    }

    /// Calculate distance between two vectors
    pub fn distance(self: Vector3, v: Vector3) f32 {
        return math.Vector3Distance(self, v);
    }

    /// Calculate square distance between two vectors
    pub fn distanceSqr(self: Vector3, v: Vector3) f32 {
        return math.Vector3DistanceSqr(self, v);
    }

    /// Calculate angle between two vectors
    pub fn angle(self: Vector3, v: Vector3) f32 {
        return math.Vector3Angle(self, v);
    }

    /// Negate vector (invert direction)
    pub fn negate(self: Vector3) Vector3 {
        return math.Vector3Negate(self);
    }

    /// Divide vector by vector
    pub fn divide(self: Vector3, v: Vector3) Vector3 {
        return math.Vector3Divide(self, v);
    }

    /// Normalize provided vector
    pub fn normalize(self: Vector3) Vector3 {
        return math.Vector3Normalize(self);
    }

    /// Calculate the projection of the vector v1 on to v2
    pub fn project(self: Vector3, v: Vector3) Vector3 {
        return math.Vector3Project(self, v);
    }

    /// Calculate the rejection of the vector v1 on to v2
    pub fn reject(self: Vector3, v: Vector3) Vector3 {
        return math.Vector3Reject(self, v);
    }

    /// Orthonormalize provided vectors Makes vectors normalized and orthogonal
    /// to each other Gram-Schmidt function implementation
    pub fn orthoNormalize(self: *Vector3, v: *Vector3) void {
        math.Vector3OrthoNormalize(self, v);
    }

    /// Transforms a Vector3 by a given Matrix
    pub fn transform(self: Vector3, mat: Matrix) Vector3 {
        return math.Vector3Transform(self, mat);
    }

    /// Transform a vector by quaternion rotation
    pub fn rotateByQuaternion(self: Vector3, q: Quaternion) Vector3 {
        return math.Vector3RotateByQuaternion(self, q);
    }

    /// Rotates a vector around an axis
    pub fn rotateByAxisAngle(self: Vector3, axis: Vector3, angle_: f32) Vector3 {
        return math.Vector3RotateByAxisAngle(self, axis, angle_);
    }

    /// Move Vector towards target
    pub fn moveTowards(self: Vector3, target: Vector3, maxDistance: f32) Vector3 {
        return math.Vector3MoveTowards(self, target, maxDistance);
    }

    /// Calculate linear interpolation between two vectors
    pub fn lerp(self: Vector3, v2: Vector3, amount: f32) Vector3 {
        return math.Vector3Lerp(self, v2, amount);
    }

    /// Calculate cubic hermite interpolation between two vectors and their tangents
    /// as described in the GLTF 2.0 specification
    pub fn cubicHermite(self: Vector3, tangent1: Vector3, v: Vector3, tangent2: Vector3, amount: f32) Vector3 {
        return math.Vector3CubicHermite(self, tangent1, v, tangent2, amount);
    }

    /// Calculate reflected vector to normal
    pub fn reflect(self: Vector3, normal: Vector3) Vector3 {
        return math.Vector3Reflect(self, normal);
    }

    /// Get min value for each pair of components
    pub fn min(self: Vector3, v: Vector3) Vector3 {
        return math.Vector3Min(self, v);
    }

    /// Get max value for each pair of components
    pub fn max(self: Vector3, v: Vector3) Vector3 {
        return math.Vector3Max(self, v);
    }

    /// Compute barycenter coordinates (u, v, w) for point p with respect to triangle
    /// (a, b, c) NOTE: Assumes P is on the plane of the triangle
    pub fn barycenter(p: Vector3, a: Vector3, b: Vector3, c: Vector3) Vector3 {
        return math.Vector3Barycenter(p, a, b, c);
    }

    /// Projects a Vector3 from screen space into object space
    /// NOTE: We are avoiding calling other raymath functions despite available
    pub fn unproject(source: Vector3, projection: Matrix, view: Matrix) Vector3 {
        return math.Vector3Unproject(source, projection, view);
    }

    /// Get Vector3 as float array
    pub fn toFloatV(self: Vector3) math.float3 {
        return math.Vector3ToFloatV(self);
    }

    /// Invert the given vector
    pub fn invert(self: Vector3) Vector3 {
        return math.Vector3Invert(self);
    }

    /// Clamp the components of the vector between min and max values specified by the given vectors
    pub fn clamp(self: Vector3, min_: Vector3, max_: Vector3) Vector3 {
        return math.Vector3Clamp(self, min_, max_);
    }

    /// Clamp the magnitude of the vector between two values
    pub fn clampValue(self: Vector3, min_: f32, max_: f32) Vector3 {
        return math.Vector3ClampValue(self, min_, max_);
    }

    /// Check whether two given vectors are almost equal
    pub fn equals(p: Vector3, q: Vector3) i32 {
        return math.Vector3Equals(p, q);
    }

    /// Compute the direction of a refracted ray
    /// v: normalized direction of the incoming ray
    /// n: normalized normal vector of the interface of two optical media
    /// r: ratio of the refractive index of the medium from where the ray comes
    ///    to the refractive index of the medium on the other side of the surface
    pub fn refract(self: Vector3, n: Vector3, r: f32) Vector3 {
        return math.Vector3Refract(self, n, r);
    }
};

pub const Vector4 = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,

    pub fn init(x: f32, y: f32, z: f32, w: f32) Vector4 {
        return Vector4{ .x = x, .y = y, .z = z, .w = w };
    }

    /// Vector with components value 0.0
    pub fn zero() Vector4 {
        return math.Vector4Zero();
    }

    /// Vector with components value 1.0
    pub fn one() Vector4 {
        return math.Vector4One();
    }

    /// Add two vectors
    pub fn add(self: Vector4, v: Vector4) Vector4 {
        return math.Vector4Add(self, v);
    }

    /// Add vector and float value
    pub fn addValue(self: Vector4, add_: f32) Vector4 {
        return math.Vector4AddValue(self, add_);
    }

    /// Subtract two vectors
    pub fn subtract(self: Vector4, v: Vector4) Vector4 {
        return math.Vector4Subtract(self, v);
    }

    /// Subtract vector and float value
    pub fn subtractValue(self: Vector4, add_: f32) Vector4 {
        return math.Vector4SubtractValue(self, add_);
    }

    /// Computes the length of a vector
    pub fn length(self: Vector4) f32 {
        return math.Vector4Length(self);
    }

    /// Calculate vector square length
    pub fn lengthSqr(self: Vector4) f32 {
        return math.Vector4LengthSqr(self);
    }

    /// Calculate two vectors dot product
    pub fn dotProduct(self: Vector4, v: Vector4) f32 {
        return math.Vector4DotProduct(self, v);
    }

    /// Calculate distance between two vectors
    pub fn distance(self: Vector4, v: Vector4) f32 {
        return math.Vector4Distance(self, v);
    }

    /// Calculate square distance between two vectors
    pub fn distanceSqr(self: Vector4, v: Vector4) f32 {
        return math.Vector4DistanceSqr(self, v);
    }

    /// Scale vector by float value
    pub fn scale(self: Vector4, scale_: f32) Vector4 {
        return math.Vector4Scale(self, scale_);
    }

    /// Multiply vector by vector
    pub fn multiply(self: Vector4, v: Vector4) Vector4 {
        return math.Vector4Multiply(self, v);
    }

    /// Negate vector
    pub fn negate(self: Vector4) Vector4 {
        return math.Vector4Negate(self);
    }

    /// Divide two vectors
    pub fn divide(self: Vector4, v: Vector4) Vector4 {
        return math.Vector4Divide(self, v);
    }

    /// Normalize vector
    pub fn normalize(self: Vector4) Vector4 {
        return math.Vector4Normalize(self);
    }

    /// Get min value for each pair of components
    pub fn min(self: Vector4, v: Vector4) Vector4 {
        return math.Vector4Min(self, v);
    }

    /// Get max value for each pair of components
    pub fn max(self: Vector4, v: Vector4) Vector4 {
        return math.Vector4Max(self, v);
    }

    /// Calculate linear interpolation between two vectors
    pub fn lerp(self: Vector4, v: Vector4, amount: f32) Vector4 {
        return math.Vector4Lerp(self, v, amount);
    }

    /// Move Vector towards target
    pub fn moveTowards(self: Vector4, target: Vector4, maxDistance: f32) Vector4 {
        return math.Vector4MoveTowards(self, target, maxDistance);
    }

    /// Invert provided quaternion
    pub fn invert(self: Vector4) Vector4 {
        return math.Vector4Invert(self);
    }

    /// Check whether two given quaternions are almost equal
    pub fn equals(p: Vector4, q: Vector4) i32 {
        return math.Vector4Equals(p, q);
    }

    /// Get identity quaternion
    pub fn identity() Quaternion {
        return math.QuaternionIdentity();
    }

    /// Calculate slerp-optimized interpolation between two quaternions
    pub fn nlerp(self: Quaternion, q: Quaternion, amount: f32) Quaternion {
        return math.QuaternionNlerp(self, q, amount);
    }

    /// Calculates spherical linear interpolation between two quaternions
    pub fn slerp(self: Quaternion, q: Quaternion, amount: f32) Quaternion {
        return math.QuaternionSlerp(self, q, amount);
    }

    /// Calculate quaternion cubic spline interpolation using Cubic Hermite Spline
    /// algorithm as described in the GLTF 2.0 specification
    pub fn cubicHermiteSpline(self: Quaternion, outTangent1: Quaternion, q: Quaternion, inTangent2: Quaternion, t: f32) Quaternion {
        return math.QuaternionCubicHermiteSpline(self, outTangent1, q, inTangent2, t);
    }

    // Calculate quaternion based on the rotation from one vector to another
    pub fn fromVector3ToVector3(from: Vector3, to: Vector3) Quaternion {
        return math.QuaternionFromVector3ToVector3(from, to);
    }

    /// Get a quaternion for a given rotation matrix
    pub fn fromMatrix(mat: Matrix) Quaternion {
        return math.QuaternionFromMatrix(mat);
    }

    /// Get a matrix for a given quaternion
    pub fn toMatrix(self: Quaternion) Matrix {
        return math.QuaternionToMatrix(self);
    }

    /// Get rotation quaternion for an angle and axis
    /// NOTE: Angle must be provided in radians
    pub fn fromAxisAngle(axis: Vector3, angle: f32) Quaternion {
        return math.QuaternionFromAxisAngle(axis, angle);
    }

    /// Get the rotation angle and axis for a given quaternion
    pub fn toAxisAngle(self: Quaternion, outAxis: *Vector3, outAngle: *f32) void {
        math.QuaternionToAxisAngle(self, outAxis, outAngle);
    }

    /// Get the quaternion equivalent to Euler angles
    /// NOTE: Rotation order is ZYX
    pub fn fromEuler(pitch: f32, yaw: f32, roll: f32) Quaternion {
        return math.QuaternionFromEuler(pitch, yaw, roll);
    }

    /// Get the Euler angles equivalent to quaternion (roll, pitch, yaw)
    /// NOTE: Angles are returned in a Vector3 struct in radians
    pub fn toEuler(self: Quaternion) Vector3 {
        return math.QuaternionToEuler(self);
    }

    /// Transform a quaternion given a transformation matrix
    pub fn transform(self: Quaternion, mat: Matrix) Quaternion {
        return math.QuaternionTransform(self, mat);
    }
};
pub const Quaternion = Vector4;

pub const Matrix = extern struct {
    m0: f32,
    m4: f32,
    m8: f32,
    m12: f32,
    m1: f32,
    m5: f32,
    m9: f32,
    m13: f32,
    m2: f32,
    m6: f32,
    m10: f32,
    m14: f32,
    m3: f32,
    m7: f32,
    m11: f32,
    m15: f32,

    /// Compute matrix determinant
    pub fn determinant(self: Matrix) f32 {
        return math.MatrixDeterminant(self);
    }

    /// Get the trace of the matrix (sum of the values along the diagonal)
    pub fn trace(self: Matrix) f32 {
        return math.MatrixTrace(self);
    }

    /// Transposes provided matrix
    pub fn transpose(self: Matrix) Matrix {
        return math.MatrixTranspose(self);
    }

    /// Invert provided matrix
    pub fn invert(self: Matrix) Matrix {
        return math.MatrixInvert(self);
    }

    /// Get identity matrix
    pub fn identity() Matrix {
        return math.MatrixIdentity();
    }

    /// Add two matrices
    pub fn add(self: Matrix, right: Matrix) Matrix {
        return math.MatrixAdd(self, right);
    }

    /// Subtract two matrices (left - right)
    pub fn subtract(self: Matrix, right: Matrix) Matrix {
        return math.MatrixSubtract(self, right);
    }

    /// Get two matrix multiplication
    /// NOTE: When multiplying matrices... the order matters!
    pub fn multiply(self: Matrix, right: Matrix) Matrix {
        return math.MatrixMultiply(self, right);
    }

    /// Get translation matrix
    pub fn translate(x: f32, y: f32, z: f32) Matrix {
        return math.MatrixTranslate(x, y, z);
    }

    /// Create rotation matrix from axis and angle
    /// NOTE: Angle should be provided in radians
    pub fn rotate(axis: Vector3, angle: f32) Matrix {
        return math.MatrixRotate(axis, angle);
    }

    /// Get x-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateX(angle: f32) Matrix {
        return math.MatrixRotateX(angle);
    }

    /// Get y-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateY(angle: f32) Matrix {
        return math.MatrixRotateY(angle);
    }

    /// Get z-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateZ(angle: f32) Matrix {
        return math.MatrixRotateZ(angle);
    }

    /// Get xyz-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateXYZ(angle: Vector3) Matrix {
        return math.MatrixRotateXYZ(angle);
    }

    /// Get zyx-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateZYX(angle: Vector3) Matrix {
        return math.MatrixRotateZYX(angle);
    }

    /// Get scaling matrix
    pub fn scale(x: f32, y: f32, z: f32) Matrix {
        return math.MatrixScale(x, y, z);
    }

    /// Get perspective projection matrix
    pub fn frustum(left: f64, right: f64, bottom: f64, top: f64, near: f64, far: f64) Matrix {
        return math.MatrixFrustum(left, right, bottom, top, near, far);
    }

    /// Get perspective projection matrix
    /// NOTE: Fovy angle must be provided in radians
    pub fn perspective(fovY: f64, aspect: f64, nearPlane: f64, farPlane: f64) Matrix {
        return math.MatrixPerspective(fovY, aspect, nearPlane, farPlane);
    }

    /// Get orthographic projection matrix
    pub fn ortho(left: f64, right: f64, bottom: f64, top: f64, nearPlane: f64, farPlane: f64) Matrix {
        return math.MatrixOrtho(left, right, bottom, top, nearPlane, farPlane);
    }

    /// Get camera look-at matrix (view matrix)
    pub fn lookAt(eye: Vector3, target: Vector3, up: Vector3) Matrix {
        return math.MatrixLookAt(eye, target, up);
    }

    /// Get float array of matrix data
    pub fn toFloatV(self: Matrix) math.float16 {
        return math.MatrixToFloatV(self);
    }
};
