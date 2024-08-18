extends Area3D
class_name LoadNextLevelZone

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		LevelManager.level_complete()
