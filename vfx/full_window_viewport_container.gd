extends SubViewportContainer
class_name FullWindowViewport

@onready var viewport = $SubViewport
@export var shader_material: ShaderMaterial
@export var shaders_enabled: bool = true

var shaders_active = false

func _ready() -> void:
# warning-ignore:return_value_discarded
	get_tree().root.size_changed.connect(self._on_window_size_changed)
	if shaders_enabled:
		toggle_effects()
	else:
		set_process_input(false)
	resize()

func _on_window_size_changed():
	resize()

func resize() -> void:
	var new_window_size = get_viewport().get_visible_rect().size
	self.size = new_window_size
	viewport.size = new_window_size

func toggle_effects() -> void:
	if shaders_active:
		material = null
	else:
		material = shader_material
	shaders_active = not shaders_active

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_toggle_viewport_effects"):
		toggle_effects()
