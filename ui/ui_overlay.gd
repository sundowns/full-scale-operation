extends CanvasLayer
class_name UiOverlay

@onready var grab_drop_label: Label = $MarginContainer/GrabbDropContainer/GrabDrop
@onready var grab_drop: HBoxContainer = $MarginContainer/GrabbDropContainer
const grab_prompt_text: String = "GRAB"
const drop_prompt_text: String = "DROP"

func _ready() -> void:
	grab_drop.visible = false

func hide_grab_drop_prompt() -> void:
	grab_drop.visible = false

func show_grab_prompt() -> void:
	grab_drop.visible = true
	grab_drop_label.text = grab_prompt_text

func show_drop_prompt() -> void:
	grab_drop.visible = true
	grab_drop_label.text = drop_prompt_text
