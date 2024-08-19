extends Node
class_name LevelDialogueManager

## Stores dialogue resources in a dictionary keyed by strings, so we can call them from elsewhere in the scene

@export var dialogue: Array[LevelDialogue] = []

@export var dialogue_style_path: String = "res://dialogue/styles/default.tres"

## { label: LevelDialogue }
var _dictionary: Dictionary = {}

## Fetches a timeline by its label and plays it
func play(dialogue_label: String) -> void:
	var dialogue_item: LevelDialogue = _get_timeline(dialogue_label)
	if dialogue_item:
		dialogue_item.play()

func _ready() -> void:
	if dialogue_style_path:
		Dialogic.Styles.load_style(dialogue_style_path)
		Dialogic.start("blank")
	for resource in dialogue:
		assert(resource.label and resource.label != "", "Unlabeled dialogue is no bueno :c")
		assert(resource.timeline, "Missing timeline from LevelDialogue")
		_dictionary[resource.label] = resource
		Dialogic.preload_timeline(resource.timeline)

func _get_timeline(label: String) -> LevelDialogue:
	if _dictionary.has(label):
		return _dictionary.get(label)
	push_error("Attempted to reference non-existent dialogue with label: %s" % label)
	return null
