extends CanvasLayer

var color_rect: ColorRect

signal finished

@export var fade_time: float = 1.0

var black_colour: Color = Color(0,0,0,1)

var tween: Tween
var transparent: Color = Color(0,0,0,0)

func _ready() -> void:
	get_tree().root.size_changed.connect(self._on_window_size_changed)
	visible = false
	Callable(initialise).call_deferred()

func initialise() -> void:
	color_rect = ColorRect.new()
	add_child(color_rect)
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT, true)
	color_rect.color = black_colour
	color_rect.z_index = 4096
	resize()

func fade_in() -> void:
	color_rect.color = black_colour
	visible = true
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(color_rect, "color", transparent, fade_time)
	await tween.finished
	finished.emit()
	visible = false

func fade_out() -> void:
	visible = true
	color_rect.color = transparent
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(color_rect, "color", black_colour, fade_time)
	await tween.finished
	finished.emit()

func fill_immediately() -> void:
	visible = true
	color_rect.color = black_colour

func empty_immediately() -> void:
	visible = true
	color_rect.color = transparent

func _on_window_size_changed():
	resize()

func resize() -> void:
	color_rect.set_deferred("size", get_viewport().size)
