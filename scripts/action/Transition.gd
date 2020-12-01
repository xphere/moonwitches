extends Node

signal completed()

enum State { Show, Hide }

export(State) var transition := State.Show
export var overlay : NodePath = "Overlay"
export var keep_overlay := false
export var duration := 1.0
export var color := Color.black


func execute() -> void:
	Game.transition.connect("completed", self, "_on_transition_completed", [], CONNECT_ONESHOT)
	if transition == State.Show:
		Game.transition.color = color
		_add_overlay()
		Game.transition.fade_in(duration)
	else:
		Game.transition.fade_out(duration)


func _on_transition_completed() -> void:
	if transition == State.Hide and not keep_overlay:
		Game.transition.clear_overlay()
	emit_signal("completed")


func _add_overlay() -> void:
	if not keep_overlay:
		Game.transition.clear_overlay()

	if not overlay or not has_node(overlay):
		return

	var node := get_node(overlay)
	var instance := node.duplicate()
	if instance is CanvasItem:
		instance.show()

	Game.transition.overlay(instance)
