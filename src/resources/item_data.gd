extends Resource
class_name ItemData

@export var sprite: Texture2D
@export_category("Scales")
## Grams
@export_range(0.25, 10000000, 0.25) var weight: float = 100.0
## Metres
@export_range(0.001, 10, 0.001) var width: float = 0.5

@export_category("Grabbing")
## Optional, otherwise calculated from width
@export var grab_shape_override: Shape3D

@export_category("Audio FX")
@export var grab_sfx: SoundEffect = preload("res://audio/sfx/menu_select_pickup.tres")
@export var drop_sfx: SoundEffect
@export var minimum_speed_for_landing_effects: float = 3.5

func get_pixel_size() -> float:
	return self.width  / self.sprite.get_width()

func get_grab_box() -> BoxShape3D:
	if grab_shape_override:
		return grab_shape_override
	## Otherwise, create one
	var new_shape: BoxShape3D = BoxShape3D.new()
	new_shape.size = Vector3(width, width, width)
	grab_shape_override = new_shape
	return new_shape
