extends Node3D
class_name Cable

func _ready() -> void:
	top_level = true

func place_between(from: Vector3, to: Vector3) -> void:
	clear()
	visible = true
	var new_line: = create_line(from, to)
	add_child(new_line)
	#global_position = from
	#look_at_from_position(from, to, Vector3.UP, true)
	#extend_to(to)

func clear() -> void:
	for child in get_children():
		child.queue_free()

func create_line(pos1: Vector3, pos2: Vector3, colour: Color = Color(1,1,1, 0.2)) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = colour
	
	return mesh_instance
