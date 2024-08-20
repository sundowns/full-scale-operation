# meta-name: Default
# meta-description: Stubbed function definitions for a Level
# meta-default: true
# meta-space-indent: 4
extends Level

func initialise() -> bool:
	## code goes here
	return super()

@warning_ignore("unused_parameter")
func _on_dialogic_signal_event(argument) -> void: pass
