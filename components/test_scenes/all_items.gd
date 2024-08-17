extends Node3D

@onready var marker_3d: Marker3D = $SpawnMarker

@onready var item_scene = preload("res://items/item.tscn")

const offset: float = 1.5
const items_per_row: int = 3

func _ready() -> void:
	DependencyHelper.store("Items", $Items)
	Callable(spawn_all_items).call_deferred()

func spawn_all_items() -> void:
	var location := marker_3d.global_position
	var count: int = 0
	for item in Items.all_items:
		var new_item := item_scene.instantiate() as Item
		new_item.data = item
		DependencyHelper.retrieve("Items").add_child(new_item)
		new_item.global_position = location
		new_item.initialise()
		count +=1
		@warning_ignore("integer_division")
		location = Vector3(offset * (count % items_per_row), 3, offset * (count / items_per_row))
