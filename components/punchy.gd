extends Node3D
class_name Punchy

@export var punch_extend_duration: float = 0.25
@export var punch_retract_duration: float = 0.1

@onready var glove: Node3D = $Glove
@onready var hitbox: Area3D = $Glove/Hitbox
@onready var collision_shape_3d: CollisionShape3D = $Glove/Hitbox/CollisionShape3D
@onready var left_end: Marker3D = $LeftEnd
@onready var right_end: Marker3D = $RightEnd

@onready var punch_sfx = {
		"1": preload("res://audio/sfx/scaleb/punch/punch_1.tres"),
		"2": preload("res://audio/sfx/scaleb/punch/punch_2.tres"),
		"3": preload("res://audio/sfx/scaleb/punch/punch_3.tres"),
		"4": preload("res://audio/sfx/scaleb/punch/punch_4.tres"),
	}

var is_punching: bool = false
var punch_tween: Tween

func _ready() -> void:
	disable_hitbox()

func swing(left: bool) -> void:
	if punch_tween and punch_tween.is_running():
		punch_tween.kill()
	glove.position = Vector3.ZERO
	var target_location: Vector3 = right_end.position
	if left:
		target_location = left_end.position
	is_punching = true
	enable_hitbox()
	var sfx = punch_sfx[punch_sfx.keys().pick_random()]
	AudioPlayer.play_sfx_at(sfx, global_position)
	
	punch_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	punch_tween.tween_property(glove, "position", target_location, punch_extend_duration)
	punch_tween.chain().tween_property(glove, "position", Vector3.ZERO, punch_retract_duration)
	await punch_tween.finished
	is_punching = false
	disable_hitbox()

func disable_hitbox() -> void:
	collision_shape_3d.disabled = true
	hitbox.set_deferred("monitorable", false)

func enable_hitbox() -> void:
	collision_shape_3d.disabled = false
	hitbox.set_deferred("monitorable", true)
