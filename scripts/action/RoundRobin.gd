extends Node

signal completed()

var _available := []
var _current := 0

export var loop := true


func _ready() -> void:
	for child in get_children():
		if child.has_method("execute") and child.has_signal("completed"):
			_available.append(child)


func execute() -> void:
	var child := get_child(_current)
	if loop:
		_current = (_current + 1) % _available.size()
	elif _current + 1 < _available.size():
		_current += 1

	child.connect("completed", self, "_on_completed_action", [], CONNECT_ONESHOT)
	child.call_deferred("execute")


func _on_completed_action() -> void:
	emit_signal("completed")
