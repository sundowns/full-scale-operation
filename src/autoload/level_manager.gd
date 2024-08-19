extends Node

signal next_level_requested

var current_level_index: int = -1

var levels: Array[PackedScene] = [
	preload("res://levels/the_great_loadathon.tscn"),
	preload("res://levels/test_world_1.tscn"),
	preload("res://levels/test_world_2.tscn"),
]

func start_game() -> void:
	self.current_level_index = 0
	self.next_level_requested.emit()

func level_complete(fade_out: bool = true) -> void:
	if fade_out:
		ScreenFade.fade_out()
		await ScreenFade.finished
	
	self.current_level_index += 1
	if self.current_level_index >= levels.size():
		print('game over babe')
	else: 
		self.next_level_requested.emit()

func get_level_scene(index: int) -> PackedScene:
	return self.levels[index]
