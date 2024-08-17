extends Area3D
class_name GrabBox

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func set_shape(new_shape: Shape3D) -> void:
	collision_shape_3d.shape = new_shape
