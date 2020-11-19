extends Node

signal completed();

export(bool) var keep_paused := false
var current : int = -1
var is_paused := false


func _ready() -> void:
	set_process(false)


func execute() -> void:
	if keep_paused:
		is_paused = true
		pause_mode = PAUSE_MODE_PROCESS
		Game.pause()

	set_process(true)
	current = 0


func _exit_tree() -> void:
	if is_paused:
		Game.unpause()


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
		child.connect("completed", self, "_on_completed_action")
		child.call_deferred("execute")

	else:
		emit_signal("completed")
		if keep_paused:
			is_paused = false
			Game.unpause()


func _on_completed_action() -> void:
	set_process(true)
