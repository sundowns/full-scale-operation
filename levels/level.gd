extends Node3D
class_name Level

signal pause
signal unpause

@onready var spawn_point: Marker3D = $PlayerSpawnPoint
@onready var camera_rig: CameraRig = $CameraRig

@export var player_scene: PackedScene = preload("res://components/player.tscn")

var player: Player

var _is_initialised: bool = false

func _exit_tree() -> void:
	if _is_initialised:
		Dialogic.signal_event.disconnect(self._on_dialogic_signal_event)

func initialise() -> void:
	DependencyHelper.store("Items", $Items)
	DependencyHelper.store("DialogueManager", $LevelDialogueManager)
	DependencyHelper.store("World", self)
	Dialogic.signal_event.connect(self._on_dialogic_signal_event, CONNECT_DEFERRED)
	spawn_player()
	_is_initialised = true

func spawn_player() -> void:
	player = player_scene.instantiate() as Player
	add_child(player)
	player.global_position = spawn_point.global_position
	camera_rig.set_target(player)
	connect_node_to_pause_signals(player)

## NOTE: override this in an inherited script from dialogue timelines if you want custom behaviour
@warning_ignore("unused_parameter")
func _on_dialogic_signal_event(argument) -> void: pass

func pause_game() -> void:
	pause.emit()

func unpause_game() -> void:
	unpause.emit()

func connect_node_to_pause_signals(node: Node) -> void:
	pause.connect(node.pause)
	unpause.connect(node.unpause)
