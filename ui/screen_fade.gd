extends CanvasLayer

var color_rect: ColorRect

signal finished

@export var fade_time: float = 1.0

var black_colour: Color = Color(0,0,0,1)
var transparent: Color = Color(0,0,0,0)
var tween: Tween

var loading_label_scene: PackedScene = preload("res://ui/loading_label.tscn")
var loading_label: Label

func _ready() -> void:
	get_tree().root.size_changed.connect(self._on_window_size_changed)
	Callable(initialise).call_deferred()

func initialise() -> void:
	color_rect = ColorRect.new()
	add_child(color_rect)
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT, true)
	color_rect.color = black_colour
	color_rect.z_index = 4096
	color_rect.visible = false
	
	var label: Label = loading_label_scene.instantiate()
	color_rect.add_child(label)
	loading_label = label
	loading_label.set_anchors_preset(Control.PRESET_CENTER, true)
	loading_label.visible = false
	
	resize()

func fade_in() -> void:
	color_rect.color = black_colour
	color_rect.visible = true
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(color_rect, "color", transparent, fade_time)
	await tween.finished
	loading_label.visible = false
	finished.emit()
	color_rect.visible = false

func fade_out() -> void:
	color_rect.visible = true
	color_rect.color = transparent
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(color_rect, "color", black_colour, fade_time)
	await tween.finished
	loading_label.visible = true
	finished.emit()

func fill_immediately() -> void:
	color_rect.visible = true
	color_rect.color = black_colour

func empty_immediately() -> void:
	color_rect.visible = false
	color_rect.color = transparent

func _on_window_size_changed():
	resize()

func resize() -> void:
	color_rect.set_deferred("size", get_viewport().size)

func show_label() -> void:
	loading_label.visible = true

func hide_label() -> void:
	loading_label.visible = false
