extends Camera3D
class_name CameraRig

## Node to follow
@export var target: Node3D

@export var offset_xz: Vector3 = Vector3(0, 0, 8)
@export_range(0, 1000000, 0.5) var fixed_height: float = 6.5
@export_range(0.1, 5, 0.1) var follow_speed: float = 1.7
@export var zoom_increment: float = 0.5
@export var zoom_in_limit: float = -2
@export var zoom_out_limit:float  = 0
var zoom: float = 0

func _ready() -> void:
	if not target:
		set_process(false)

func set_target(new_target: Node3D) -> void:
	target = new_target
	set_process(true)

func _process(delta: float) -> void:
	if not target: return
	Callable(move_towards_target).call_deferred(delta)
	
	if Input.is_action_just_released("scroll_up"):
		zoom -= zoom_increment
	elif Input.is_action_just_released("scroll_down"):
		zoom += zoom_increment
	zoom = clamp(zoom, zoom_in_limit, zoom_out_limit)

func move_towards_target(delta: float) -> void:
	var target_position = target.global_position
	if target is Player:
		target_position = target.get_extrapolated_position(delta)
	var new_camera_position = target_position + offset_xz
	new_camera_position.y = fixed_height
	new_camera_position += Vector3(0, zoom, zoom)
	
	global_position = lerp(global_position, new_camera_position, delta * (follow_speed - zoom_increment * zoom ))
