extends Node

signal completed();

var amount : int


func execute() -> void:
	amount = 0
	for child in get_children():
		if child.has_method("execute") and child.has_signal("completed"):
			amount += 1
			child.connect("completed", self, "_on_completed_action", child)
			child.call_deferred("execute")


func _on_completed_action(child: Node) -> void:
	child.disconnect("completed", self, "_on_completed_action")
	amount -= 1
	if amount == 0:
		emit_signal("completed")
