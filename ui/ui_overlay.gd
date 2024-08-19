extends CanvasLayer
class_name UiOverlay

@onready var right_margin_container: MarginContainer = $Right
@onready var grab_drop_label: Label = $Right/GrabbDropContainer/GrabDrop
@onready var grab_drop: HBoxContainer = $Right/GrabbDropContainer
const grab_prompt_text: String = "GRAB"
const drop_prompt_text: String = "DROP"

## a ratio for resizing shit
const input_prompt_offset_from_right: float = float(660)/float(1920)

func _ready() -> void:
	get_tree().root.size_changed.connect(self._on_window_size_changed)
	grab_drop.visible = false

func hide_grab_drop_prompt() -> void:
	grab_drop.visible = false

func show_grab_prompt() -> void:
	grab_drop.visible = true
	grab_drop_label.text = grab_prompt_text

func show_drop_prompt() -> void:
	grab_drop.visible = true
	grab_drop_label.text = drop_prompt_text

func _on_window_size_changed():
	var window_size: Vector2i = get_viewport().size
	@warning_ignore("narrowing_conversion")
	right_margin_container.add_theme_constant_override("margin_right", input_prompt_offset_from_right * window_size.x)
