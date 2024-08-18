extends RigidBody3D
class_name Item

@export var data: ItemData

@onready var sprite: Sprite3D = $Sprite3D
@onready var grab_box: GrabBox = $GrabBox
@onready var weight_component: WeightComponent = $WeightComponent
@onready var floor_detection: RayCast3D = $CollisionShape3D/RayCast3D

@export var highlight_material: ShaderMaterial = preload("res://vfx/item_highlight_material.tres")
@export var follow_speed = 15
@export var follow_speed_max = 20
@export var follow_speed_min = 2
@export var weight_weight = 80000

var _is_initialised: bool = false
var is_being_held: bool =false
var is_on_floor: bool = false

func _ready() -> void:
	if data:
		initialise()

## Read the data collection and set values
func initialise() -> void:
	highlight_material = highlight_material.duplicate()
	_is_initialised = true
	sprite.texture = data.sprite
	sprite.pixel_size = data.get_pixel_size()
	grab_box.set_shape(data.get_grab_box())
	weight_component.set_weight(data.weight)
	highlight_material.set_shader_parameter("sprite_texture", data.sprite)

func _process(delta: float) -> void:
	if is_being_held:
		global_position = lerp(global_position, get_parent().global_position, get_follow_speed() * delta)
	else:
		if floor_detection.is_colliding():
			freeze = true
		else:
			freeze = false
		

func _physics_process(delta: float) -> void:
	if not is_being_held and not is_on_floor:
		if floor_detection.is_colliding():
			_on_landing()
	

func get_follow_speed() -> float:
	var speed = remap(data.weight, 0, weight_weight,  follow_speed_max, follow_speed_min)
	return clamp(speed, follow_speed_min, follow_speed_max)

func _on_pickup() -> void:
	top_level = true
	is_being_held = true
	freeze = true
	is_on_floor = false
	floor_detection.enabled = false
	AudioPlayer.play_sfx(data.grab_sfx)

func _on_drop() -> void:
	top_level = false
	is_being_held = false
	freeze = false
	floor_detection.enabled = true
	
func _on_landing() -> void:
	freeze = true
	floor_detection.enabled = false
	AudioPlayer.play_sfx(data.drop_sfx)

func _mark_as_target_for_pickup() -> void:
	sprite.material_override = highlight_material

func _unmark_as_target_for_pickup() -> void:
	sprite.material_override = null
