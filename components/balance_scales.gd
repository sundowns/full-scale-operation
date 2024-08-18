extends Node3D
class_name BalanceScales

@onready var arm: Node3D = $scales_arm
@export var max_rotation_degrees: float = 20.0

var rotation_tween: Tween

var current_weight_ratio: float = 0.0:
	set = _set_weight_ratio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_to_new_rotation_ratio(0.0)

func move_to_new_rotation_ratio(ratio: float) -> void:
	if rotation_tween and rotation_tween.is_running():
		rotation_tween.kill()
	rotation_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	# TODO: tween some shit
	#current_weight_ratio = ratio
	rotation_tween.tween_property(self, "current_weight_ratio", ratio, 2.5)
	#current_weight_ratio = ratio # TODO: not this, just tween it
	#_set_weight_ratio(ratio)

## Ratio is a number between -1.0 and 1.0, that represents the left-to-right weight distribution
func _set_weight_ratio(ratio: float) -> void:
	current_weight_ratio = ratio
	var rotation_in_degrees: float = remap(ratio, -1, 1.0, -max_rotation_degrees, max_rotation_degrees)
	update_arm_rotation(rotation_in_degrees)

func update_arm_rotation(new_value: float) -> void:
	arm.rotation_degrees = Vector3(clampf(new_value, -max_rotation_degrees, max_rotation_degrees), 0, 0)
