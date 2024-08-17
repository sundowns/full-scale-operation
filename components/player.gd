extends CharacterBody3D
class_name Player

@onready var sprite_3d: Sprite3D = $Sprite3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var time_since_physics_frame: float = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	time_since_physics_frame = 0

func _process(delta: float) -> void:
	time_since_physics_frame += delta
	sprite_3d.global_position = global_position + velocity * time_since_physics_frame
	handle_sprite_rotation()

func handle_sprite_rotation() -> void:
	var direction := velocity.normalized()
	if direction.is_equal_approx(Vector3.ZERO) or direction > Vector3.ZERO:
		sprite_3d.flip_h = false
	else:
		sprite_3d.flip_h = true
		
