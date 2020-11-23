extends Node

signal completed()

export(NodePath) var trigger : NodePath = "trigger"
export(NodePath) var action : NodePath = "action"
export(bool) var disabled := false


func _ready() -> void:
	var parent := get_parent()
	if parent.has_signal("completed") and parent.has_method("execute"):
		return
	execute()


func execute() -> void:
	var _trigger := get_node(trigger)
	_trigger.connect("triggered", self, "_on_trigger_triggered")


func _on_trigger_triggered() -> void:
	if disabled:
		return

	disabled = true
	var _action := get_node(action)
	_action.connect("completed", self, "_on_action_completed", [ _action ])
	_action.execute()


func _on_action_completed(_action: Node) -> void:
	disabled = false
	_action.disconnect("completed", self, "_on_action_completed")
	emit_signal("completed")
