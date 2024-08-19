extends Level

@onready var lamp_2: Lamp = $Lamp2

func _on_dialogic_signal_event(argument) -> void:
	if argument is String:
		match argument:
			"cat":
				lamp_2.turn_on()
