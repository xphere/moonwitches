extends Node

signal triggered()

var _connected := 0


func _ready() -> void:
	for child in get_children():
		if child.has_signal("triggered"):
			child.connect("triggered", self, "_on_child_triggered", [], CONNECT_ONESHOT)
			_connected += 1


func _on_child_triggered() -> void:
	_connected -= 1
	if _connected == 0:
		emit_signal("triggered")
