extends Node

var all_items: Array[ItemData] = [
	preload("res://items/data/bowling_ball.tres"),
	preload("res://items/data/anvil.tres"),
]

func get_random_item(exclusions: Array[ItemData] = []) -> ItemData:
	var selection: ItemData = null
	while selection == null or exclusions.has(selection):
		selection = all_items.pick_random()
	return selection
