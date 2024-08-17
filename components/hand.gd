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
		held_thing = current_grabbable_thing
		#var parent = held_thing.get_parent()
		#parent.remove_child(held_thing)
		held_thing.reparent(self, true)
		#add_child(held_thing)
		if held_thing is Item:
			held_thing._on_pickup()

func drop_thing() -> void:
	assert(held_thing != null, "Look what you've fuckin' done....")
	#remove_child(held_thing)
	if held_thing is Item:
		held_thing.reparent(DependencyHelper.retrieve("Items"), true)
		#DependencyHelper.retrieve("Items").add_child(held_thing)
		#held_thing.global_position = global_position
		held_thing._on_drop()
	else:
		push_error("Tried to drop somethig that isn't item - where should we put it in the scene :[")
	held_thing = null

func _on_graboss_area_entered(area: Area3D) -> void:
	if area is GrabBox:
		if current_grabbable_thing and current_grabbable_thing is Item:
			if current_grabbable_thing is Item:
				current_grabbable_thing._unmark_as_target_for_pickup()
		current_grabbable_thing = area.get_parent()
		if current_grabbable_thing is Item:
			current_grabbable_thing._mark_as_target_for_pickup()

func _on_graboss_area_exited(area: Area3D) -> void:
	if area is GrabBox:
		if area.get_parent() == current_grabbable_thing:
			if current_grabbable_thing is Item:
				current_grabbable_thing._unmark_as_target_for_pickup()
			current_grabbable_thing = null
