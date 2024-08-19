extends Control

@onready var game_scene: PackedScene = preload("res://game.tscn")
@onready var fullscreen_toggle: CheckButton = $BottomMiddle/VBoxContainer/FullscreenToggle

var is_fullscreen: bool = false

func _ready() -> void:
	fullscreen_toggle.button_pressed = is_fullscreen
	set_fullscreen(is_fullscreen)
	get_tree().root.size_changed.connect(self._on_window_size_changed)

func start_game() -> void:
	ScreenFade.fade_out()
	await ScreenFade.finished
	get_tree().change_scene_to_packed(game_scene)

func _on_play_pressed():
	start_game()

func _on_window_size_changed() -> void:
	var new_window_size := get_tree().root.get_viewport().get_visible_rect().size
	set_deferred("size", new_window_size)
	set_position(Vector2i.ZERO)

func set_fullscreen(val: bool) -> void:
	if val:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_fullscreen_toggle_pressed():
	is_fullscreen = not is_fullscreen
	set_fullscreen(is_fullscreen)
