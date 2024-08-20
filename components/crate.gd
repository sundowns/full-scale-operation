extends StaticBody3D
class_name ItemCrate

signal smashed

const health: int = 1
@export var items: Array[ItemData] = [] 

@onready var smash_particles: GPUParticles3D = $CrateSmashParticles
@onready var mesh: Node3D = $Mesh
@onready var smashma: Area3D = $Smashma
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var item_spawn_location: Marker3D = $ItemSpawnLocation

@export var smash_sounds: Array[SoundEffect] = [
	preload("res://audio/sfx/crate_smash_1.tres"),
	preload("res://audio/sfx/crate_smash_2.tres"),
	preload("res://audio/sfx/crate_smash_3.tres"),
]

var item_scene: PackedScene = preload("res://items/item.tscn")
var current_health: int = 1
var is_freeing: bool = false

func _ready() -> void:
	current_health = health

func update_health(delta: int) -> void:
	current_health += delta
	if current_health <= 0:
		smash()

func _on_smashma_area_entered(_area: Area3D) -> void:
	update_health(-1)

func smash() -> void:
	if is_freeing: return
	is_freeing = true
	collision_shape_3d.set_deferred("disabled", true)
	mesh.visible = false
	spawn_items()
	smashma.queue_free()
	AudioPlayer.play_sfx_at(smash_sounds.pick_random(), global_position)
	smash_particles.emitting = true
	await smash_particles.finished
	smashed.emit()
	queue_free()

func spawn_items() -> void:
	var emission_force: float = 3.5
	var up_vector := Vector3.UP
	for item_data in items:
		var new_item = item_scene.instantiate() as Item
		new_item.data = item_data
		DependencyHelper.retrieve("Items").add_child(new_item)
		new_item.global_position = item_spawn_location.global_position
		new_item.initialise()
		var emission_vector = (up_vector + Vector3(randf_range(-0.4, 0.4) ,0, randf_range(-0.4, 0.4))) * emission_force
		new_item.apply_central_impulse(emission_vector)
