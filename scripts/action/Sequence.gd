extends Node

signal completed()

var current : int = -1


func _ready() -> void:
	set_process(false)


func execute() -> void:
	set_process(true)
	current = 0


func _process(_delta: float) -> void:
	set_process(false)

	if current < 0:
		return

	var child : Node
	while current < get_child_count():
		child = get_child(current)
		current += 1
		if child.has_method("execute") and child.has_signal("completed"):
			break
		child = null

	if child:
		child.connect("completed", self, "_on_completed_action", [], CONNECT_ONESHOT)
		child.call_deferred("execute")

	else:
		call_deferred("_on_children_processed")


func _on_completed_action() -> void:
	set_process(true)


func _on_children_processed() -> void:
	emit_signal("completed")
