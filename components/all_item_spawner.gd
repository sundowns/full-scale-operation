extends Marker3D

@onready var item_scene = preload("res://items/item.tscn")

const offset: float = 1.5
const items_per_row: int = 6

func _ready() -> void:
	Callable(spawn_all_items).call_deferred()


func spawn_all_items() -> void:
	var count: int = 0
	for item in Items.all_items:
		var new_item := item_scene.instantiate() as Item
		new_item.data = item
		DependencyHelper.retrieve("Items").add_child(new_item)
		@warning_ignore("integer_division")
		new_item.global_position = global_position + Vector3(offset * (count % items_per_row), 3, offset * (count / items_per_row))
		new_item.initialise()
		count +=1
