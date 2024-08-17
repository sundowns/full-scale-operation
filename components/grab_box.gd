extends Area3D
class_name GrabBox

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var is_currently_grabbed: bool = false

func set_shape(new_shape: Shape3D) -> void:
	collision_shape_3d.shape = new_shape

func grab() -> void:
	is_currently_grabbed = true

func release() -> void:
	is_currently_grabbed = false
