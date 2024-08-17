extends Node

var all_items: Array[ItemData] = [
	preload("res://items/data/baseball_bat.tres"),
	preload("res://items/data/axe.tres"),
	preload("res://items/data/anvil.tres"),
	preload("res://items/data/bowling_ball.tres"),
]

const item_data_directory: String = "res://items/data/"
const load_resources_from_filesystem: bool = false

func _ready() -> void:
	if load_resources_from_filesystem:
		populate_all_items()

func get_random_item(exclusions: Array[ItemData] = []) -> ItemData:
	var selection: ItemData = null
	while selection == null or exclusions.has(selection):
		selection = all_items.pick_random()
	return selection

func populate_all_items() -> void:
	all_items = []
	var directory: DirAccess = DirAccess.open(item_data_directory) 
	assert(directory, "Oh no we can't load our items :c")
	for file in directory.get_files():
		all_items.push_back(load(item_data_directory + file))
	print("Loaded %d items" % all_items.size())
