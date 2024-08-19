extends Node3D
class_name Level

@onready var spawn_point: Marker3D = $PlayerSpawnPoint
@onready var camera_rig: CameraRig = $CameraRig

@export var player_scene: PackedScene = preload("res://components/player.tscn")

var player: Player

func initialise() -> void:
	DependencyHelper.store("Items", $Items)
	DependencyHelper.store("DialogueManager", $LevelDialogueManager)
	spawn_player()

func spawn_player() -> void:
	player = player_scene.instantiate() as Player
	add_child(player)
	player.global_position = spawn_point.global_position
	camera_rig.set_target(player)
