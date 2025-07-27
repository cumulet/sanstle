# MirrorReflection.gd
# Godot 4.x port of Unity's MirrorReflection.cs
#
# USAGE:
# 1. Attach this script to your Mirror plane (MeshInstance3D).
# 2. Ensure the MeshInstance3D has a ShaderMaterial with a `reflection_tex` uniform:
#    ```glsl
#    shader_type spatial;
#    uniform sampler2D reflection_tex;
#    void fragment() {
#        ALBEDO = texture(reflection_tex, UV).rgb;
#    }
#    ```
# 3. Adjust `texture_size`, `clip_plane_offset`, and `reflect_layers` as needed.

extends MeshInstance3D

@export var texture_size: int = 512           # Resolution of the reflection texture
@export var clip_plane_offset: float = 0.07   # Offset to avoid near-plane artifacts
@export var reflect_layers: int = 0xFFFFFFFF  # Bitmask: which layers the mirror reflects

var sub_viewport: SubViewport
var reflection_camera: Camera3D
var viewport_texture: Texture2D

func _ready():
	# 1) Create an offscreen SubViewport for rendering reflections
	sub_viewport = SubViewport.new()
	sub_viewport.name = "MirrorViewport"
	sub_viewport.size = Vector2i(texture_size, texture_size)
	sub_viewport.transparent_bg = true
	# Use the main 3D world so it shows your scene
	sub_viewport.world_3d = get_world_3d()
		# Always update the render texture
	
	add_child(sub_viewport)

	# 2) Create a reflection Camera3D inside the SubViewport
	reflection_camera = Camera3D.new()
	reflection_camera.current = true
	reflection_camera.cull_mask = reflect_layers
	sub_viewport.add_child(reflection_camera)

	# 3) Assign the SubViewport's texture to the mirror material
	viewport_texture = sub_viewport.get_texture()
	var mat: Material
	if material_override:
		mat = material_override
	elif mesh.get_surface_count() > 0 and mesh.surface_get_material(0):
		mat = mesh.surface_get_material(0).duplicate()
	else:
		mat = ShaderMaterial.new()
		push_warning("MirrorReflection: No existing material; created new ShaderMaterial.")

	if mat is ShaderMaterial:
		mat.set_shader_parameter("reflection_tex", viewport_texture)
	elif mat is StandardMaterial3D:
		mat.albedo_texture = viewport_texture
	else:
		push_warning("MirrorReflection: Unsupported material type; texture not assigned.")
	material_override = mat

func _process(delta: float) -> void:
	# Find the active camera in the scene
	var cam = get_viewport().get_camera_3d()
	if cam == null:
		return

	# Mirror plane definition
	var plane_pos: Vector3 = global_transform.origin
	var plane_normal: Vector3 = global_transform.basis.y.normalized()

	# Reflect camera position
	var to_cam: Vector3 = cam.global_transform.origin - plane_pos
	var reflected_pos: Vector3 = to_cam - 2 * plane_normal.dot(to_cam) * plane_normal
	reflection_camera.global_transform.origin = plane_pos + reflected_pos

	# Reflect camera direction
	var forward: Vector3 = -cam.global_transform.basis.z.normalized()
	var reflected_dir: Vector3 = forward - 2 * plane_normal.dot(forward) * plane_normal
	reflection_camera.look_at(reflection_camera.global_transform.origin + reflected_dir, Vector3.UP)

	# Copy projection settings
	reflection_camera.fov = cam.fov
	reflection_camera.near = clip_plane_offset
	reflection_camera.far = cam.far
	reflection_camera.projection = cam.projection

	# Tip: Ensure your plane has proper UVs or you'll see a white texture.
	# Godot 4 lacks oblique clip-plane support; use custom projection or shaders for clipping.
