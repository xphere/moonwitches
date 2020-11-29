extends Node

signal completed()

export(bool) var disabled := false setget set_disable
export(bool) var once := true
export(bool) var pause := true

onready var _trigger := $trigger
onready var _action := $action


func _ready() -> void:
	add_to_group("restorable")
	if not disabled:
		_connect_to_trigger()


func set_disable(value: bool) -> void:
	if _trigger and _action:
		_set_disable(value)
	else:
		disabled = value


func _set_disable(value: bool) -> void:
	disabled = value
	if disabled:
		_disconnect_from_trigger()
	else:
		_connect_to_trigger()


func _connect_to_trigger() -> void:
	_trigger.connect("triggered", self, "_on_trigger")


func _disconnect_from_trigger() -> void:
	_trigger.disconnect("triggered", self, "_on_trigger")


func _connect_to_action_completed() -> void:
	_action.connect("completed", self, "_on_action_completed", [], CONNECT_ONESHOT)


func _on_trigger() -> void:
	if disabled:
		return

	_set_disable(true)
	_connect_to_action_completed()

	if pause:
		Game.pause()
		connect("completed", self, "_unpause")
		connect("tree_exiting", self, "_unpause")

	_action.execute()


func _on_action_completed() -> void:
	emit_signal("completed")
	if not once:
		_set_disable(false)


func _unpause() -> void:
	Game.unpause()
	disconnect("completed", self, "_unpause")
	disconnect("tree_exiting", self, "_unpause")


func save() -> Dictionary:
	return {
		"disabled": disabled,
	}


func restore(data: Dictionary) -> void:
	if disabled != data["disabled"]:
		_set_disable(data["disabled"])
