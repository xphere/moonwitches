extends Node

signal completed()

export(bool) var keep_paused := true
var current : int = -1
var is_paused := false


func _ready() -> void:
	set_process(false)


func execute() -> void:
	if keep_paused:
		pause_mode = PAUSE_MODE_PROCESS
		connect("tree_exiting", self, "_unpause")
		connect("completed", self, "_unpause")
		is_paused = true
		Game.pause()

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
		emit_signal("completed")


func _on_completed_action() -> void:
	set_process(true)


func _unpause() -> void:
	if not is_paused:
		return

	is_paused = false
	Game.unpause()
