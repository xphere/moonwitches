extends Node
class_name Device

signal activate()
signal deactivate()

export(bool) var state := false setget _set_state


func _set_state(value: bool) -> void:
	if value == state:
		return
	state = value
	if state:
		emit_signal("activate")
	else:
		emit_signal("deactivate")
