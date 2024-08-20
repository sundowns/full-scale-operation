extends Node3D
class_name ItemGenerator

@onready var item_scene: PackedScene = preload("res://items/item.tscn")

@onready var spawn_location: Marker3D = $SpawnLocation
@onready var player_detection_area: PlayerDetectionArea = $PlayerDetectionArea

@export var spawn_item_sfx: SoundEffect

## There's no time to explain
@export var anvil_mode: bool = false

func _ready() -> void:
	player_detection_area.player_entered.connect(self._on_player_detected, CONNECT_DEFERRED)

func _on_player_detected() -> void:
	var item: ItemData
	if anvil_mode:
		item = preload("res://items/data/anvil.tres")
	else:
		item = Items.get_random_item()
	spawn_item_at(spawn_location.global_position, item)

func spawn_item_at(at: Vector3, data: ItemData) -> void:
	var new_item = item_scene.instantiate() as Item
	new_item.data = data
	DependencyHelper.retrieve("Items").add_child(new_item)
	new_item.global_position = at
	new_item.initialise()
	AudioPlayer.play_sfx_at(spawn_item_sfx, at)
	
