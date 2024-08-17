extends Node3D
class_name Item

@export var data: ItemData

@onready var sprite: Sprite3D = $Sprite3D
@onready var grab_box: GrabBox = $GrabBox

var _is_initialised: bool = false

func _ready() -> void:
	if data:
		initialise()

## Read the data collection and set values
func initialise() -> void:
	_is_initialised = true
	sprite.texture = data.sprite
	sprite.pixel_size = data.pixel_size
	grab_box.set_shape(data.grab_box_shape)

func _on_pickup() -> void: pass
func _on_drop() -> void: pass
