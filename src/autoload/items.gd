extends Node

var all_items: Array[ItemData] = [
	preload("res://items/data/anvil.tres"),
	preload("res://items/data/axe.tres"),
	preload("res://items/data/baseball_bat.tres"),
	preload("res://items/data/battery.tres"),
	preload("res://items/data/book.tres"),
	preload("res://items/data/bowling_ball.tres"),
	preload("res://items/data/brief_case.tres"),
	preload("res://items/data/canned_food.tres"),
	preload("res://items/data/car_tyre.tres"),
	preload("res://items/data/coffee_pot.tres"),
	preload("res://items/data/coffee_table.tres"),
	preload("res://items/data/feather.tres"),
	preload("res://items/data/fish_bowl.tres"),
	preload("res://items/data/frying_pan.tres"),
	preload("res://items/data/hammer.tres"),
	preload("res://items/data/impact_wrench.tres"),
	preload("res://items/data/key.tres"),
	preload("res://items/data/laptop.tres"),
	preload("res://items/data/lead_pipe.tres"),
	preload("res://items/data/leaf.tres"),
	preload("res://items/data/mug.tres"),
	preload("res://items/data/nail.tres"),
	preload("res://items/data/paper.tres"),
	preload("res://items/data/paperclip.tres"),
	preload("res://items/data/pencil.tres"),
	preload("res://items/data/potataz.tres"),
	preload("res://items/data/pot_plant.tres"),
	preload("res://items/data/rock_large.tres"),
	preload("res://items/data/rock_small.tres"),
	preload("res://items/data/rug.tres"),
	preload("res://items/data/screw.tres"),
	preload("res://items/data/television.tres"),
	preload("res://items/data/toothbrush.tres"),
	preload("res://items/data/water_bottle.tres"),
]

const item_data_directory: String = "res://items/data/"
const load_resources_from_filesystem: bool = true

func _ready() -> void:
	if not OS.has_feature("release") or load_resources_from_filesystem:
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
