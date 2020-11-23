extends Node

signal completed()

export(NodePath) var action : NodePath


func execute() -> void:
	var node := get_node(action)

	node.connect("completed", self, "_on_completed_action", [], CONNECT_ONESHOT)
	node.call_deferred("execute")


func _on_completed_action() -> void:
	emit_signal("completed")
