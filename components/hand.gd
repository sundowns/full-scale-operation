extends Node3D
class_name Hand

var current_grabbable_thing: Node3D
var held_thing: Node3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("graboss"):
		if held_thing:
			drop_thing()
		else:
			try_to_grab_thing()

func try_to_grab_thing() -> void:
	if current_grabbable_thing:
		current_grabbable_thing._unmark_as_target_for_pickup()
		held_thing = current_grabbable_thing
		DependencyHelper.retrieve("UI").show_drop_prompt()
		held_thing.reparent(self, true)
		if held_thing is Item:
			held_thing._on_pickup()

func drop_thing() -> void:
	assert(held_thing != null, "Look what you've fuckin' done....")
	if held_thing is Item:
		held_thing.reparent(DependencyHelper.retrieve("Items"), true)
		held_thing._on_drop()
		DependencyHelper.retrieve("UI").hide_grab_drop_prompt()
	else:
		push_error("Tried to drop somethig that isn't item - where should we put it in the scene :[")
	held_thing = null

func _on_graboss_area_entered(area: Area3D) -> void:
	if area is GrabBox:
		if area.get_parent() == held_thing:
			return
		if current_grabbable_thing and current_grabbable_thing is Item:
			if current_grabbable_thing is Item:
				current_grabbable_thing._unmark_as_target_for_pickup()
		current_grabbable_thing = area.get_parent()
		if held_thing == null:
			DependencyHelper.retrieve("UI").show_grab_prompt()
		if current_grabbable_thing is Item:
			current_grabbable_thing._mark_as_target_for_pickup()

func _on_graboss_area_exited(area: Area3D) -> void:
	if area is GrabBox:
		if area.get_parent() == current_grabbable_thing:
			if current_grabbable_thing is Item:
				current_grabbable_thing._unmark_as_target_for_pickup()
			current_grabbable_thing = null
			if held_thing == null:
				DependencyHelper.retrieve("UI").hide_grab_drop_prompt()
