extends ColorRect

signal finished

@export var fade_time: float = 1.0

var black_colour: Color = Color(0,0,0,1)

var tween: Tween
var transparent: Color = Color(0,0,0,0)

func _ready() -> void:
	color = black_colour
	z_index = 3000
	visible = false
	size = get_viewport().size

func fade_in() -> void:
	color = black_colour
	visible = true
	tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(self, "color", transparent, fade_time)
	await tween.finished
	finished.emit()
	visible = false

func fade_out() -> void:
	visible = true
	color = transparent
	tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "color", black_colour, fade_time)
	await tween.finished
	finished.emit()
