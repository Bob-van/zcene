const safety = @import("safety.zig");

const math = @import("math.zig");
const Vector3 = math.Vector3;
const Matrix = math.Matrix;
const Quaternion = math.Quaternion;

const uncategorized = @import("uncategorized.zig");
const Color = uncategorized.Color;
const Image = uncategorized.Image;
const Texture = uncategorized.Texture;

pub const Mesh = extern struct {
    vertexCount: c_int,
    triangleCount: c_int,
    vertices: [*c]f32,
    texcoords: [*c]f32,
    texcoords2: [*c]f32,
    normals: [*c]f32,
    tangents: [*c]f32,
    colors: [*c]u8,
    indices: [*c]c_ushort,
    animVertices: [*c]f32,
    animNormals: [*c]f32,
    boneIds: [*c]u8,
    boneWeights: [*c]f32,
    boneMatrices: [*c]Matrix,
    boneCount: c_int,
    vaoId: c_int,
    vboId: [*c]c_int,

    extern fn UploadMesh(mesh: [*c]Mesh, dynamic: bool) void;
    /// Upload mesh vertex data in GPU and provide VAO/VBO ids
    pub fn initMemory(mesh: *Mesh, dynamic: bool) void {
        safety.load();
        UploadMesh(@ptrCast(mesh), dynamic);
    }

    extern fn GenMeshPoly(sides: c_int, radius: f32) Mesh;
    /// Generate polygonal mesh
    pub fn initPoly(sides: i32, radius: f32) Mesh {
        safety.load();
        return GenMeshPoly(sides, radius);
    }

    extern fn GenMeshPlane(width: f32, length: f32, resX: c_int, resZ: c_int) Mesh;
    /// Generate plane mesh (with subdivisions)
    pub fn initPlane(width: f32, length: f32, resX: i32, resZ: i32) Mesh {
        safety.load();
        return GenMeshPlane(width, length, resX, resZ);
    }

    extern fn GenMeshCube(width: f32, height: f32, length: f32) Mesh;
    /// Generate cuboid mesh
    pub fn initCube(width: f32, height: f32, length: f32) Mesh {
        safety.load();
        return GenMeshCube(width, height, length);
    }

    extern fn GenMeshSphere(radius: f32, rings: c_int, slices: c_int) Mesh;
    /// Generate sphere mesh (standard sphere)
    pub fn initSphere(radius: f32, rings: i32, slices: i32) Mesh {
        safety.load();
        return GenMeshSphere(radius, rings, slices);
    }

    extern fn GenMeshHemiSphere(radius: f32, rings: c_int, slices: c_int) Mesh;
    /// Generate half-sphere mesh (no bottom cap)
    pub fn initHemiSphere(radius: f32, rings: i32, slices: i32) Mesh {
        safety.load();
        return GenMeshHemiSphere(radius, rings, slices);
    }

    extern fn GenMeshCylinder(radius: f32, height: f32, slices: c_int) Mesh;
    /// Generate cylinder mesh
    pub fn initCylinder(radius: f32, height: f32, slices: i32) Mesh {
        safety.load();
        return GenMeshCylinder(radius, height, slices);
    }

    extern fn GenMeshCone(radius: f32, height: f32, slices: c_int) Mesh;
    /// Generate cone/pyramid mesh
    pub fn initCone(radius: f32, height: f32, slices: i32) Mesh {
        safety.load();
        return GenMeshCone(radius, height, slices);
    }

    extern fn GenMeshTorus(radius: f32, size: f32, radSeg: c_int, sides: c_int) Mesh;
    /// Generate torus mesh
    pub fn initTorus(radius: f32, size: f32, radSeg: i32, sides: i32) Mesh {
        safety.load();
        return GenMeshTorus(radius, size, radSeg, sides);
    }

    extern fn GenMeshKnot(radius: f32, size: f32, radSeg: c_int, sides: c_int) Mesh;
    /// Generate trefoil knot mesh
    pub fn initKnot(radius: f32, size: f32, radSeg: i32, sides: i32) Mesh {
        safety.load();
        return GenMeshKnot(radius, size, radSeg, sides);
    }

    extern fn GenMeshHeightmap(heightmap: Image, size: Vector3) Mesh;
    /// Generate heightmap mesh from image data
    pub fn initHeightmap(heightmap: Image, size: Vector3) Mesh {
        safety.load();
        return GenMeshHeightmap(heightmap, size);
    }

    extern fn GenMeshCubicmap(cubicmap: Image, cubeSize: Vector3) Mesh;
    /// Generate cubes-based map mesh from image data
    pub fn initCubicmap(cubicmap: Image, cubeSize: Vector3) Mesh {
        safety.load();
        return GenMeshCubicmap(cubicmap, cubeSize);
    }

    extern fn UnloadMesh(mesh: Mesh) void;
    /// Unload mesh data from CPU and GPU
    pub fn deinit(self: Mesh) void {
        safety.unload();
        UnloadMesh(self);
    }

    extern fn UpdateMeshBuffer(mesh: Mesh, index: c_int, data: ?*const anyopaque, dataSize: c_int, offset: c_int) void;
    /// Update mesh vertex data in GPU for a specific buffer index
    pub fn updateBuffer(mesh: Mesh, index: i32, data: *const anyopaque, dataSize: i32, offset: i32) void {
        UpdateMeshBuffer(mesh, index, data, dataSize, offset);
    }

    extern fn DrawMesh(mesh: Mesh, material: Material, transform: Matrix) void;
    /// Draw a 3d mesh with material and transform
    pub fn draw(self: Mesh, material: Material, transform: Matrix) void {
        safety.drawingBegun();
        DrawMesh(self, material, transform);
    }

    extern fn DrawMeshInstanced(mesh: Mesh, material: Material, transforms: [*c]const Matrix, instances: c_int) void;
    /// Draw multiple mesh instances with material and different transforms
    pub fn drawInstanced(self: Mesh, material: Material, transforms: []const Matrix) void {
        safety.drawingBegun();
        DrawMeshInstanced(self, material, @ptrCast(transforms.ptr), @intCast(transforms.len));
    }

    extern fn GetMeshBoundingBox(mesh: Mesh) BoundingBox;
    /// Compute mesh bounding box limits
    pub fn boundingBox(mesh: Mesh) BoundingBox {
        return GetMeshBoundingBox(mesh);
    }

    extern fn GenMeshTangents(mesh: [*c]Mesh) void;
    /// Compute mesh tangents
    pub fn genTangents(mesh: *Mesh) void {
        GenMeshTangents(@ptrCast(mesh));
    }

    extern fn ExportMesh(mesh: Mesh, fileName: [*c]const u8) bool;
    /// Export mesh data to file, returns true on success
    pub fn toFile(mesh: Mesh, fileName: [:0]const u8) bool {
        return ExportMesh(mesh, @ptrCast(fileName));
    }

    extern fn ExportMeshAsCode(mesh: Mesh, fileName: [*c]const u8) bool;
    /// Export mesh as code file (.h) defining multiple arrays of vertex attributes
    pub fn toCode(mesh: Mesh, fileName: [:0]const u8) bool {
        return ExportMeshAsCode(mesh, @ptrCast(fileName));
    }
};

pub const Shader = extern struct {
    id: c_uint,
    locs: [*c]c_int,

    pub const Error = error{InvalidShader};

    pub const LocationIndex = enum(c_int) {
        vertex_position = 0,
        vertex_texcoord01 = 1,
        vertex_texcoord02 = 2,
        vertex_normal = 3,
        vertex_tangent = 4,
        vertex_color = 5,
        matrix_mvp = 6,
        matrix_view = 7,
        matrix_projection = 8,
        matrix_model = 9,
        matrix_normal = 10,
        vector_view = 11,
        color_diffuse = 12,
        color_specular = 13,
        color_ambient = 14,
        map_albedo = 15,
        map_metalness = 16,
        map_normal = 17,
        map_roughness = 18,
        map_occlusion = 19,
        map_emission = 20,
        map_height = 21,
        map_cubemap = 22,
        map_irradiance = 23,
        map_prefilter = 24,
        map_brdf = 25,
        vertex_boneids = 26,
        vertex_boneweights = 27,
        bone_matrices = 28,
        shader_loc_vertex_instance_tx = 29,
    };

    pub const UniformDataType = enum(c_int) {
        float = 0,
        vec2 = 1,
        vec3 = 2,
        vec4 = 3,
        int = 4,
        ivec2 = 5,
        ivec3 = 6,
        ivec4 = 7,
        sampler2d = 8,
    };

    pub const Attribute = enum(c_int) {
        float = 0,
        vec2 = 1,
        vec3 = 2,
        vec4 = 3,
    };

    /// Check if a shader is valid (loaded on GPU)
    extern fn IsShaderValid(shader: Shader) bool;

    extern fn LoadShader(vsFileName: [*c]const u8, fsFileName: [*c]const u8) Shader;
    /// Load shader from files and bind default locations
    pub fn initFile(vsFileName: ?[:0]const u8, fsFileName: ?[:0]const u8) Error!Shader {
        var vsFileNameFinal: [*c]const u8 = null;
        var fsFileNameFinal: [*c]const u8 = null;
        if (vsFileName) |vsFileNameSure| {
            vsFileNameFinal = @ptrCast(vsFileNameSure);
        }
        if (fsFileName) |fsFileNameSure| {
            fsFileNameFinal = @ptrCast(fsFileNameSure);
        }
        const shader = LoadShader(vsFileNameFinal, fsFileNameFinal);
        if (!IsShaderValid(shader)) return Error.InvalidShader;
        safety.load();
        return shader;
    }

    extern fn LoadShaderFromMemory(vsCode: [*c]const u8, fsCode: [*c]const u8) Shader;
    /// Load shader from code strings and bind default locations
    pub fn initMemory(vsCode: ?[:0]const u8, fsCode: ?[:0]const u8) Error!Shader {
        var vsCodeFinal: [*c]const u8 = null;
        var fsCodeFinal: [*c]const u8 = null;
        if (vsCode) |vsCodeSure| {
            vsCodeFinal = @ptrCast(vsCodeSure);
        }
        if (fsCode) |fsCodeSure| {
            fsCodeFinal = @ptrCast(fsCodeSure);
        }
        const shader = LoadShaderFromMemory(vsCodeFinal, fsCodeFinal);
        if (!IsShaderValid(shader)) return Error.InvalidShader;
        safety.load();
        return shader;
    }

    extern fn UnloadShader(shader: Shader) void;
    /// Unload shader from GPU memory (VRAM)
    pub fn deinit(shader: Shader) void {
        safety.unload();
        UnloadShader(shader);
    }

    extern fn BeginShaderMode(shader: Shader) void;
    /// Begin custom shader drawing
    pub fn begin(self: Shader) void {
        BeginShaderMode(self);
    }

    extern fn EndShaderMode() void;
    /// End custom shader drawing (use default shader)
    pub fn end(_: Shader) void {
        EndShaderMode();
    }

    extern fn GetShaderLocation(shader: Shader, uniformName: [*c]const u8) c_int;
    /// Get shader uniform location
    pub fn getLocation(shader: Shader, uniformName: [:0]const u8) i32 {
        return GetShaderLocation(shader, @ptrCast(uniformName));
    }

    extern fn GetShaderLocationAttrib(shader: Shader, attribName: [*c]const u8) c_int;
    /// Get shader attribute location
    pub fn getLocationAttrib(shader: Shader, attribName: [:0]const u8) i32 {
        return GetShaderLocationAttrib(shader, @ptrCast(attribName));
    }

    extern fn SetShaderValue(shader: Shader, locIndex: c_int, value: ?*const anyopaque, uniformType: c_int) void;
    /// Set shader uniform value
    pub fn setValue(shader: Shader, locIndex: i32, value: *const anyopaque, uniformType: Shader.UniformDataType) void {
        SetShaderValue(shader, @as(c_int, locIndex), value, @intFromEnum(uniformType));
    }

    extern fn SetShaderValueV(shader: Shader, locIndex: c_int, value: ?*const anyopaque, uniformType: c_int, count: c_int) void;
    /// Set shader uniform value vector
    pub fn setValueV(shader: Shader, locIndex: i32, value: *const anyopaque, uniformType: Shader.UniformDataType, count: i32) void {
        SetShaderValueV(shader, locIndex, value, @intFromEnum(uniformType), count);
    }

    extern fn SetShaderValueMatrix(shader: Shader, locIndex: c_int, mat: Matrix) void;
    /// Set shader uniform value (matrix 4x4)
    pub fn setValueMatrix(shader: Shader, locIndex: i32, mat: Matrix) void {
        SetShaderValueMatrix(shader, locIndex, mat);
    }

    extern fn SetShaderValueTexture(shader: Shader, locIndex: c_int, texture: Texture) void;
    /// Set shader uniform value and bind the texture (sampler2d)
    pub fn setValueTexture(shader: Shader, locIndex: i32, texture: Texture) void {
        SetShaderValueTexture(shader, locIndex, texture);
    }
};

pub const Material = extern struct {
    shader: Shader,
    maps: [*c]Material.Map,
    params: [4]f32,

    pub const Error = error{InvalidMaterial};

    pub const Map = extern struct {
        texture: Texture,
        color: Color,
        value: f32,

        pub const Index = enum(c_int) {
            albedo = 0,
            metalness = 1,
            normal = 2,
            roughness = 3,
            occlusion = 4,
            emission = 5,
            height = 6,
            cubemap = 7,
            irradiance = 8,
            prefilter = 9,
            brdf = 10,
        };
    };

    /// Check if a material is valid (shader assigned, map textures loaded in GPU)
    extern fn IsMaterialValid(material: Material) bool;

    extern fn LoadMaterials(fileName: [*c]const u8, materialCount: [*c]c_int) [*c]Material;
    /// Load materials from model file
    pub fn initFile(fileName: [:0]const u8) Error![]Material {
        var materialCount: c_int = 0;
        const ptr = LoadMaterials(@ptrCast(fileName), @ptrCast(&materialCount));
        if (ptr == 0) return Error.InvalidMaterial;
        const ret: []Material = ptr[0..@intCast(materialCount)];
        for (ret, 0..) |material, i| {
            if (!IsMaterialValid(material)) {
                for (0..i) |loaded| {
                    ret[loaded].deinit();
                }
                return Error.InvalidMaterial;
            }
            safety.load();
        }
        return ret;
    }

    extern fn UnloadMaterial(material: Material) void;
    /// Unload material from GPU memory (VRAM)
    pub fn deinit(self: Material) void {
        safety.unload();
        UnloadMaterial(self);
    }

    extern fn LoadMaterialDefault() Material;
    /// Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps) (dont deinit)
    pub fn default() Error!Material {
        const material = LoadMaterialDefault();
        return if (IsMaterialValid(material)) material else Error.InvalidMaterial;
    }

    extern fn SetMaterialTexture(material: [*c]Material, mapType: c_int, texture: Texture) void;
    /// Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
    pub fn setTexture(material: *Material, mapType: Material.Map.Index, texture: Texture) void {
        SetMaterialTexture(@ptrCast(material), @intFromEnum(mapType), texture);
    }
};

pub const Model = extern struct {
    transform: Matrix,
    meshCount: c_int,
    materialCount: c_int,
    meshes: [*c]Mesh,
    materials: [*c]Material,
    meshMaterial: [*c]c_int,
    boneCount: c_int,
    bones: [*c]Bone,
    bindPose: [*c]Transform,

    pub const Error = error{InvalidModel};

    pub const Bone = extern struct {
        name: [32]u8,
        parent: c_int,
    };

    pub const Transform = extern struct {
        translation: Vector3,
        rotation: Quaternion,
        scale: Vector3,
    };

    /// Check if a model is valid (loaded in GPU, VAO/VBOs)
    extern fn IsModelValid(model: Model) bool;

    extern fn LoadModel(fileName: [*c]const u8) Model;
    /// Load model from file (meshes and materials)
    pub fn initFile(fileName: [:0]const u8) Error!Model {
        const model = LoadModel(@ptrCast(fileName));
        if (!IsModelValid(model)) return Error.InvalidModel;
        safety.load();
        return model;
    }

    extern fn LoadModelFromMesh(mesh: Mesh) Model;
    /// Load model from generated mesh (default material)
    pub fn initMesh(mesh: Mesh) Error!Model {
        const model = LoadModelFromMesh(mesh);
        if (!IsModelValid(model)) return Error.InvalidModel;
        safety.load();
        return model;
    }

    extern fn UnloadModel(model: Model) void;
    /// Unload model (including meshes) from memory (RAM and/or VRAM)
    pub fn unload(self: Model) void {
        safety.unload();
        UnloadModel(self);
    }

    extern fn GetModelBoundingBox(model: Model) BoundingBox;
    /// Compute model bounding box limits (considers all meshes)
    pub fn boundingBox(model: Model) BoundingBox {
        return GetModelBoundingBox(model);
    }

    extern fn DrawModel(model: Model, position: Vector3, scale: f32, tint: Color) void;
    /// Draw a model (with texture if set)
    pub fn draw(model: Model, position: Vector3, scale: f32, tint: Color) void {
        safety.drawingBegun();
        DrawModel(model, position, scale, tint);
    }

    extern fn DrawModelEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void;
    /// Draw a model with extended parameters
    pub fn drawEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void {
        safety.drawingBegun();
        DrawModelEx(model, position, rotationAxis, rotationAngle, scale, tint);
    }

    extern fn DrawModelWires(model: Model, position: Vector3, scale: f32, tint: Color) void;
    /// Draw a model wires (with texture if set)
    pub fn drawWires(model: Model, position: Vector3, scale: f32, tint: Color) void {
        safety.drawingBegun();
        DrawModelWires(model, position, scale, tint);
    }

    extern fn DrawModelWiresEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void;
    /// Draw a model wires (with texture if set) with extended parameters
    pub fn drawWiresEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void {
        safety.drawingBegun();
        DrawModelWiresEx(model, position, rotationAxis, rotationAngle, scale, tint);
    }

    extern fn DrawModelPoints(model: Model, position: Vector3, scale: f32, tint: Color) void;
    /// Draw a model as points
    pub fn drawPoints(model: Model, position: Vector3, scale: f32, tint: Color) void {
        safety.drawingBegun();
        DrawModelPoints(model, position, scale, tint);
    }

    extern fn DrawModelPointsEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void;
    /// Draw a model as points with extended parameters
    pub fn drawPointsEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void {
        safety.drawingBegun();
        DrawModelPointsEx(model, position, rotationAxis, rotationAngle, scale, tint);
    }

    extern fn SetModelMeshMaterial(model: [*c]Model, meshId: c_int, materialId: c_int) void;
    /// Set material for a mesh
    pub fn setMeshMaterial(model: *Model, meshId: i32, materialId: i32) void {
        SetModelMeshMaterial(@ptrCast(model), meshId, materialId);
    }

    pub const Animation = extern struct {
        boneCount: c_int,
        frameCount: c_int,
        bones: [*c]Model.Bone,
        framePoses: [*c][*c]Model.Transform,
        name: [32]u8,

        pub const Error = error{InvalidModelAnimation};

        extern fn LoadModelAnimations(fileName: [*c]const u8, animCount: [*c]c_int) [*c]Animation;
        /// Load model animations from file
        pub fn initFile(fileName: []const u8) Animation.Error![]Animation {
            var len: c_int = 0;
            const ptr = LoadModelAnimations(@ptrCast(fileName), &len);
            if (ptr == 0) return Animation.Error.InvalidModelAnimation;
            for (0..@intCast(len)) |_| safety.load();
            return ptr[0..@intCast(len)];
        }

        extern fn UnloadModelAnimation(anim: Animation) void;
        /// Unload animation data
        pub fn deinit(self: Animation) void {
            safety.unload();
            UnloadModelAnimation(self);
        }

        extern fn UnloadModelAnimations(animations: [*c]Animation, animCount: c_int) void;
        /// Unload animation data
        pub fn deinitAll(animations: []Animation) void {
            for (animations) |_| safety.unload();
            UnloadModelAnimations(@ptrCast(animations.ptr), @intCast(animations.len));
        }

        extern fn UpdateModelAnimation(model: Model, anim: Animation, frame: c_int) void;
        /// Update model animation pose (CPU)
        pub fn update(self: Animation, model: Model, frame: i32) void {
            UpdateModelAnimation(model, self, frame);
        }

        extern fn UpdateModelAnimationBones(model: Model, anim: Animation, frame: c_int) void;
        /// Update model animation mesh bone matrices (GPU skinning)
        pub fn updateBones(self: Animation, model: Model, frame: i32) void {
            UpdateModelAnimationBones(model, self, frame);
        }

        extern fn IsModelAnimationValid(model: Model, anim: Animation) bool;
        /// Check model animation skeleton match
        pub fn isValidFor(self: Animation, model: Model) bool {
            return IsModelAnimationValid(model, self);
        }
    };
};

pub const BoundingBox = extern struct {
    min: Vector3,
    max: Vector3,

    extern fn DrawBoundingBox(box: BoundingBox, color: Color) void;
    /// Draw bounding box (wires)
    pub fn draw(self: BoundingBox, color: Color) void {
        safety.drawingBegun();
        DrawBoundingBox(self, color);
    }

    extern fn CheckCollisionBoxes(box1: BoundingBox, box2: BoundingBox) bool;
    /// Check collision between two bounding boxes
    pub fn collisionBox(self: BoundingBox, other: BoundingBox) bool {
        return CheckCollisionBoxes(self, other);
    }

    extern fn CheckCollisionBoxSphere(box: BoundingBox, center: Vector3, radius: f32) bool;
    /// Check collision between box and sphere
    pub fn collisionSphere(self: BoundingBox, center: Vector3, radius: f32) bool {
        return CheckCollisionBoxSphere(self, center, radius);
    }
};

pub const Ray = extern struct {
    position: Vector3,
    direction: Vector3,

    extern fn DrawRay(ray: Ray, color: Color) void;
    /// Draw a ray line
    pub fn draw(self: Ray, color: Color) void {
        safety.drawingBegun();
        DrawRay(self, color);
    }

    pub const Collision = extern struct {
        hit: bool,
        distance: f32,
        point: Vector3,
        normal: Vector3,
    };

    extern fn GetRayCollisionSphere(ray: Ray, center: Vector3, radius: f32) Ray.Collision;
    /// Get collision info between ray and sphere
    pub fn collisionSphere(self: Ray, center: Vector3, radius: f32) Ray.Collision {
        return GetRayCollisionSphere(self, center, radius);
    }

    extern fn GetRayCollisionBox(ray: Ray, box: BoundingBox) Ray.Collision;
    /// Get collision info between ray and box
    pub fn collisionBox(self: Ray, box: BoundingBox) Ray.Collision {
        return GetRayCollisionBox(self, box);
    }

    extern fn GetRayCollisionMesh(ray: Ray, mesh: Mesh, transform: Matrix) Ray.Collision;
    /// Get collision info between ray and mesh
    pub fn collisionMesh(self: Ray, mesh: Mesh, transform: Matrix) Ray.Collision {
        return GetRayCollisionMesh(self, mesh, transform);
    }

    extern fn GetRayCollisionTriangle(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3) Ray.Collision;
    /// Get collision info between ray and triangle
    pub fn collisionTriangle(self: Ray, p1: Vector3, p2: Vector3, p3: Vector3) Ray.Collision {
        return GetRayCollisionTriangle(self, p1, p2, p3);
    }

    extern fn GetRayCollisionQuad(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3, p4: Vector3) Ray.Collision;
    /// Get collision info between ray and quad
    pub fn collisionQuad(self: Ray, p1: Vector3, p2: Vector3, p3: Vector3, p4: Vector3) Ray.Collision {
        return GetRayCollisionQuad(self, p1, p2, p3, p4);
    }
};
