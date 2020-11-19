extends Node

signal completed();

export(NodePath) var trigger : NodePath = "trigger"
export(NodePath) var action : NodePath = "action"
export(bool) var disabled := false


func _ready() -> void:
	if disabled:
		queue_free()
	var parent := get_parent()
	if parent.has_signal("completed") and parent.has_method("execute"):
		return
	execute()


func execute() -> void:
	var _trigger := get_node(trigger)
	var _action := get_node(action)

	_trigger.connect("triggered", _action, "execute")
	_action.connect("completed", self, "_on_action_completed")


func _on_action_completed() -> void:
	emit_signal("completed")
