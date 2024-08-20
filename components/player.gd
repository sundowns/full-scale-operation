extends CharacterBody3D
class_name Player

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var hand: Hand = $Hand
@onready var punchy: Punchy = $Punchy
@onready var punch_sprite: Sprite3D = $PunchSprite

@onready var left_thruster_remote_transform: RemoteTransform3D = $LeftThrusterLocation
@onready var right_thruster_remote_transform: RemoteTransform3D = $RightThrusterLocation
@onready var thruster_particles: GPUParticles3D = $ThrusterParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var jump_sfx = {
		"1": preload("res://audio/sfx/scaleb/jump/jump_1.tres"),
		"2": preload("res://audio/sfx/scaleb/jump/jump_2.tres"),
		"3": preload("res://audio/sfx/scaleb/jump/jump_3.tres"),
		"4": preload("res://audio/sfx/scaleb/jump/jump_4.tres"),
		"5": preload("res://audio/sfx/scaleb/jump/jump_5.tres"),
		"6": preload("res://audio/sfx/scaleb/jump/jump_6.tres"),
	}

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var time_since_physics_frame: float = 0.0
var hand_offset: Vector3 = Vector3.ZERO
var additional_speed: float = 0.0

func _ready() -> void:
	sprite_3d.top_level = true
	hand_offset = hand.position
	punch_sprite.visible = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * (SPEED + additional_speed)
		velocity.z = direction.z * (SPEED + additional_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED + additional_speed))
		velocity.z = move_toward(velocity.z, 0, (SPEED + additional_speed))

	move_and_slide()
	time_since_physics_frame = 0
	thruster_particles.emitting = Vector3(velocity.x, 0, velocity.z).length() > 0 
	
	if Input.is_action_just_pressed("punch"):
		if not punchy.is_punching:
			if not sprite_3d.flip_h:
				animation_player.play("punch_left")
				punchy.swing(true)
			else:
				animation_player.play("punch_right")
				punchy.swing(false)

func _process(delta: float) -> void:
	time_since_physics_frame += delta
	sprite_3d.global_position = get_extrapolated_position()
	hand.global_position = sprite_3d.global_position + hand_offset
	
	handle_sprite_rotation()

func get_extrapolated_position(additional_time: float = 0) -> Vector3:
	return global_position + velocity * (time_since_physics_frame + additional_time)

func jump():
	velocity.y = JUMP_VELOCITY + ( 0.35 * additional_speed )
	var sfx = jump_sfx[jump_sfx.keys().pick_random()]
	AudioPlayer.play_sfx_at(sfx, global_position)

func handle_sprite_rotation() -> void:
	var direction := velocity.normalized()
	if direction.x > 0:
		face_right()
	elif direction.x < 0:
		face_left()

func face_left() -> void:
	sprite_3d.flip_h = false
	right_thruster_remote_transform.update_position = false
	right_thruster_remote_transform.update_rotation = false
	left_thruster_remote_transform.update_position = true
	left_thruster_remote_transform.update_rotation = true

func face_right() -> void:
	sprite_3d.flip_h = true
	left_thruster_remote_transform.update_position = false
	left_thruster_remote_transform.update_rotation = false
	right_thruster_remote_transform.update_position = true
	right_thruster_remote_transform.update_rotation = true

func _on_hand_dropped_thing() -> void:
	additional_speed = 0.0

func _on_hand_grabbed_thing(weight: Variant) -> void:
	additional_speed = remap(weight, 0, 100000,  0, -5)

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
