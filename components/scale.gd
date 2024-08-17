extends StaticBody3D
class_name Scale

@export var test_item: ItemData
@export_range(0, 1, 10000) var error_margin: float = 10 

@onready var scale_test_area: ScaleArea = $LeftDish/ScaleArea
@onready var test_item_sprite: Sprite3D = $RightDish/TestItemSprite

func _ready() -> void:
	if test_item:
		initialise()

func initialise() -> void:
	scale_test_area.set_goal_weight(test_item.weight - error_margin, test_item.weight + error_margin)
	test_item_sprite.texture = test_item.sprite
	test_item_sprite.pixel_size = test_item.pixel_size
