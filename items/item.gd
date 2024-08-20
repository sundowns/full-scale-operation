extends RigidBody3D
class_name Item

@export var data: ItemData

@onready var sprite: Sprite3D = $Sprite3D
@onready var grab_box: GrabBox = $GrabBox
@onready var weight_component: WeightComponent = $WeightComponent
@onready var floor_detection: RayCast3D = $CollisionShape3D/RayCast3D

@export var highlight_material: ShaderMaterial = preload("res://vfx/item_highlight_material.tres")
@export var follow_speed = 15
@export var follow_speed_max = 20
@export var follow_speed_min = 2
@export var weight_weight = 80000

var _is_initialised: bool = false
var is_being_held: bool =false
var is_on_floor: bool = false

const base_glow_size: float = 25.0

func _ready() -> void:
	if data:
		initialise()

## Read the data collection and set values
func initialise() -> void:
	if _is_initialised:
		return
	highlight_material = highlight_material.duplicate()
	sprite.texture = data.sprite
	sprite.pixel_size = data.get_pixel_size()
	#print(data.get_pixel_size())
	grab_box.set_shape(data.get_grab_box())
	weight_component.set_weight(data.weight)
	highlight_material.set_shader_parameter("sprite_texture", data.sprite)
	highlight_material.set_shader_parameter("glowSize", base_glow_size * 1.0/data.width)
	
	Callable(connect_to_pause).call_deferred()
	_is_initialised = true

func connect_to_pause() -> void:
	DependencyHelper.retrieve("World").connect_node_to_pause_signals(self)

func _process(delta: float) -> void:
	if is_being_held:
		global_position = lerp(global_position, get_parent().global_position, get_follow_speed() * delta)

func _physics_process(_delta: float) -> void:
	if not is_being_held:
		if not is_on_floor and not freeze:
			if floor_detection.is_colliding():
				_on_landing()
		elif not floor_detection.is_colliding():
			freeze = false # we need to check if we have started falling by other means (notably, the scale lowering)

func get_follow_speed() -> float:
	var speed = remap(data.weight, 0, weight_weight,  follow_speed_max, follow_speed_min)
	return clamp(speed, follow_speed_min, follow_speed_max)

func _on_pickup() -> void:
	top_level = true
	is_being_held = true
	freeze = true
	is_on_floor = false
	AudioPlayer.play_sfx(data.grab_sfx)

func _on_drop() -> void:
	top_level = false
	is_being_held = false
	freeze = false

func _on_landing() -> void:
	freeze = true
	if linear_velocity.length() > data.minimum_speed_for_landing_effects:
		play_landing_effect()

func play_landing_effect() -> void:
	AudioPlayer.play_sfx_at(data.drop_sfx, global_position)

func _mark_as_target_for_pickup() -> void:
	sprite.material_override = highlight_material

func _unmark_as_target_for_pickup() -> void:
	sprite.material_override = null

var _is_paused: bool = false
func pause() -> void:
	_is_paused = true
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)

func unpause() -> void:
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	set_process_internal(true)
	set_process_unhandled_input(true)
	set_process_unhandled_key_input(true)
	_is_paused = false
