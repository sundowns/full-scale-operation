extends RigidBody3D
class_name Item

@export var data: ItemData

@onready var sprite: Sprite3D = $Sprite3D
@onready var grab_box: GrabBox = $GrabBox
@onready var weight_component: WeightComponent = $WeightComponent

@export var highlight_material: ShaderMaterial = preload("res://vfx/item_highlight_material.tres")

var _is_initialised: bool = false
var is_being_held: bool =false

func _ready() -> void:
	if data:
		initialise()

## Read the data collection and set values
func initialise() -> void:
	highlight_material = highlight_material.duplicate()
	_is_initialised = true
	sprite.texture = data.sprite
	sprite.pixel_size = data.pixel_size
	grab_box.set_shape(data.grab_box_shape)
	weight_component.set_weight(data.weight)
	highlight_material.set_shader_parameter("sprite_texture", data.sprite)

func _process(delta: float) -> void:
	if is_being_held:
		global_position = lerp(global_position, get_parent().global_position, data.follow_speed * delta)
	#look_at(DependencyHelper.retrieve("Camera").global_position)

func _on_pickup() -> void:
	top_level = true
	is_being_held = true
	freeze = true

func _on_drop() -> void:
	top_level = false
	is_being_held = false
	freeze = false

func _mark_as_target_for_pickup() -> void:
	sprite.material_override = highlight_material

func _unmark_as_target_for_pickup() -> void:
	sprite.material_override = null
