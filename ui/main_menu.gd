extends Control

@onready var game_scene: PackedScene = preload("res://game.tscn")

func start_game() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _on_play_pressed():
	start_game()
