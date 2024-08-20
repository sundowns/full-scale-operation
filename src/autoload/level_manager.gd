extends Node

signal next_level_requested

var current_level_index: int = -1

var levels: Array[PackedScene] = [
	#preload("res://levels/the_great_loadathon.tscn"),
	#preload("res://levels/test_world_1.tscn"),
	#preload("res://levels/intro.tscn"),
	preload("res://levels/test_chamber_1.tscn"),
]

var game_over_scene: PackedScene = preload("res://ui/thanks_for_playing.tscn")

func start_game() -> void:
	self.current_level_index = 0
	self.next_level_requested.emit()

func level_complete(fade_out: bool = true) -> void:
	if fade_out:
		ScreenFade.fade_out()
		await ScreenFade.finished
	
	self.current_level_index += 1
	if self.current_level_index >= levels.size():
		ScreenFade.empty_immediately()
		ScreenFade.hide_label()
		get_tree().change_scene_to_packed(game_over_scene)
	else: 
		self.next_level_requested.emit()

func get_level_scene(index: int) -> PackedScene:
	return self.levels[index]
