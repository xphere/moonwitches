extends Node

signal completed()

export(bool) var disabled := false
export(bool) var once := true
export(bool) var pause := true

onready var _trigger := $trigger
onready var _action := $action


func _ready() -> void:
	if not disabled:
		_connect_to_trigger()


func set_disable(value: bool) -> void:
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

	_disconnect_from_trigger()
	_connect_to_action_completed()

	if pause:
		Game.pause()
		connect("completed", self, "_unpause")
		connect("tree_exiting", self, "_unpause")

	_action.execute()


func _on_action_completed() -> void:
	emit_signal("completed")
	if once:
		queue_free()
	else:
		_connect_to_trigger()


func _unpause() -> void:
	Game.unpause()
	disconnect("tree_exiting", self, "_unpause")
