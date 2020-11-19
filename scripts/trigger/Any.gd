extends Node

signal triggered()


func _ready() -> void:
	for child in get_children():
		if child.has_signal("triggered"):
			child.connect("triggered", self, "_on_child_triggered")


func _on_child_triggered() -> void:
	emit_signal("triggered")
