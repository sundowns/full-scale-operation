extends Node
class_name LevelDialogueManager

## Stores dialogue resources in a dictionary keyed by strings, so we can call them from elsewhere in the scene

@export var dialogue: Array[LevelDialogue] = []

## { label: LevelDialogue }
var _dictionary: Dictionary = {}

## Fetches a timeline by its label and plays it
func play(timeline_label: String) -> void:
	print('?')
	Dialogic.start("test")
	var timeline := _get_timeline(timeline_label)
	if timeline:
		#print(timeline)
		Dialogic.start_timeline(timeline)

func _ready() -> void:
	for resource in dialogue:
		assert(resource.label and resource.label != "", "Unlabeled dialogue is no bueno :c")
		assert(resource.timeline, "Missing timeline from LevelDialogue")
		_dictionary[resource.label] = resource.timeline

func _get_timeline(label: String) -> DialogicTimeline:
	if _dictionary.has(label):
		return _dictionary.get(label)
	push_error("Attempted to reference non-existent dialogue with label: %s" % label)
	return null
