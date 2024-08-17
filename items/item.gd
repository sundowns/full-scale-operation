extends RigidBody3D
class_name Item

@export var data: ItemData

@onready var sprite: Sprite3D = $Sprite3D
@onready var grab_box: GrabBox = $GrabBox
@onready var weight_component: WeightComponent = $WeightComponent

var _is_initialised: bool = false
var is_being_held: bool =false

func _ready() -> void:
	if data:
		initialise()

## Read the data collection and set values
func initialise() -> void:
	_is_initialised = true
	sprite.texture = data.sprite
	sprite.pixel_size = data.pixel_size
	grab_box.set_shape(data.grab_box_shape)
	weight_component.set_weight(data.weight)

func _process(delta: float) -> void:
	if is_being_held:
		global_position = lerp(global_position, get_parent().global_position, data.follow_speed * delta)

func _on_pickup() -> void:
	top_level = true
	is_being_held = true
	freeze = true

func _on_drop() -> void:
	top_level = false
	is_being_held = false
	freeze = false
