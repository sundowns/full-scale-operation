extends Node3D
class_name Lamp

@export var start_on: bool = false
@export var on_material: StandardMaterial3D = preload("res://vfx/lamp_on_material.tres")
@export var off_material: StandardMaterial3D = preload("res://vfx/lamp_off_material.tres")

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var is_on: bool = false

func _ready() -> void:
	if start_on:
		turn_on()
	else:
		turn_off()

func turn_off() -> void:
	is_on = false
	mesh_instance_3d.material_override = off_material

func turn_on() -> void:
	is_on = true
	mesh_instance_3d.material_override = on_material
