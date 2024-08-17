extends Node

var all_items: Array[ItemData] = []

const item_data_directory: String = "res://items/data/"

func _ready() -> void:
	populate_all_items()

func get_random_item(exclusions: Array[ItemData] = []) -> ItemData:
	var selection: ItemData = null
	while selection == null or exclusions.has(selection):
		selection = all_items.pick_random()
	return selection

func populate_all_items() -> void:
	var directory: DirAccess = DirAccess.open(item_data_directory) 
	assert(directory, "Oh no we can't load our items :c")
	for file in directory.get_files():
		all_items.push_back(load(item_data_directory + file))
	print("Loaded %d items" % all_items.size())
