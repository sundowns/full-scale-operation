extends Resource
class_name ItemData

@export var sprite: Texture2D
## Grams
@export var weight: float = 1.0

## Metres
@export var pixel_size: float = 0.01 

@export_category("Grabbing")
@export var grab_box_shape: Shape3D = BoxShape3D.new()
@export var follow_speed: float = 1.5
