extends Resource
class_name ItemData

@export var sprite: Texture2D
@export_category("Scales")
## Grams
@export var weight: float = 1.0
## Metres
@export_range(0.001, 10, 0.001) var width: float = 0.5

@export_category("Grabbing")
@export var grab_box_shape: Shape3D = BoxShape3D.new()
@export var follow_speed: float = 6

func get_pixel_size() -> float:
	return self.width  / self.sprite.get_width()

# image_size * pixel_size = ingame_width
