extends Node3D

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
	grab_box.set_shape(data.grab_box_shape)
