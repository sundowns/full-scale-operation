extends StaticBody3D
class_name Scale

signal scale_valid
signal scale_invalid

@export var test_item: ItemData
@export_range(0, 1, 10000) var error_margin: float = 100
@export_range(0.1, 100, 0.1) var dish_move_speed: float = 1.0

@onready var scale_test_area: ScaleArea = $LeftDish/ScaleArea
@onready var test_item_sprite: Sprite3D = $RightDish/TestItemSprite

@onready var left_dish: MeshInstance3D = $LeftDish
@onready var right_dish: MeshInstance3D = $RightDish

@onready var left_bottom: Marker3D = $LeftBottom
@onready var left_top: Marker3D = $LeftTop
@onready var right_bottom: Marker3D = $RightBottom
@onready var right_top: Marker3D = $RightTop

@onready var balance_scales: BalanceScales = $BalanceScales

var left_target_height: float = 0.0
var right_target_height: float = 0.0
var is_active: bool = false

func _ready() -> void:
	if test_item:
		initialise()
	update_scales()

func initialise() -> void:
	scale_test_area.set_goal_weight(test_item.weight - error_margin, test_item.weight + error_margin)
	test_item_sprite.texture = test_item.sprite
	test_item_sprite.pixel_size = test_item.get_pixel_size()

func update_scales() -> void:
	var current_vs_goal_ratio: float = clampf(scale_test_area.current_weight / test_item.weight, 0.0, 2.0)
	update_dish_positions(current_vs_goal_ratio)
	var left_to_right_ratio: float = remap(current_vs_goal_ratio, 0.0, 2.0, -1.0, 1.0)
	balance_scales.move_to_new_rotation_ratio(left_to_right_ratio)

func update_dish_positions(current_vs_goal_ratio: float) -> void:
	var left_height_ratio: = current_vs_goal_ratio / 2.0
	var right_height_ratio: = (1.0 - current_vs_goal_ratio/2)
	left_target_height = lerp(left_top.position.y, left_bottom.position.y, left_height_ratio)
	right_target_height = lerp(right_top.position.y, right_bottom.position.y, right_height_ratio)
	is_active = true

func _on_scale_area_weight_updated() -> void:
	update_scales()

func _process(delta: float) -> void:
	if is_active:
		var left_height: float = lerp(left_dish.position.y, left_target_height, delta * dish_move_speed)
		left_dish.position.y = clampf(left_height, left_bottom.position.y, left_top.position.y)
		var right_height: float = lerp(right_dish.position.y, right_target_height, delta * dish_move_speed)
		right_dish.position.y = clampf(right_height, right_bottom.position.y, right_top.position.y)

func _on_scale_area_weight_goal_activated() -> void:
	scale_valid.emit()

func _on_scale_area_weight_goal_deactivated() -> void:
	scale_invalid.emit()
