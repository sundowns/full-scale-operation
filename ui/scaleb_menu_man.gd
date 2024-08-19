extends TextureRect

@export var target_list: Control
var points: Array[Marker2D] = []
@export var minimum_delay: float = 0.3
@export var maximum_delay: float = 4.0

@export var minimum_movement_duration: float = 0.5
@export var maximum_movement_duration: float = 1.3

@onready var random_delay: Timer = $RandomDelay

var current_point_index: int = -1
var movement_tween: Tween

var last_location: Vector2 = Vector2.ZERO

func _ready() -> void:
	for child in target_list.get_children():
		if child is Marker2D:
			points.push_back(child)
	last_location = global_position
	random_delay.start(0.75)

func seek_next_point() -> void:
	var new_index: int = -1
	while new_index == -1 or new_index == current_point_index:
		new_index = randi_range(0, points.size()-1)
	current_point_index = new_index
	tween_towards(points[current_point_index].global_position)

func tween_towards(location: Vector2) -> void:
	if movement_tween and movement_tween.is_running():
		movement_tween.kill()
	movement_tween = create_tween().set_ease(Tween.EaseType.EASE_IN_OUT).set_trans(Tween.TransitionType.TRANS_SINE)
	movement_tween.tween_property(self, "global_position", location, randf_range(minimum_movement_duration, maximum_movement_duration))
	
	flip_h = location.x > global_position.x
	
	await movement_tween.finished
	random_delay.start(randf_range(minimum_delay, maximum_delay))

func _on_random_delay_timeout() -> void:
	seek_next_point()
