extends Node

signal completed()

export(String) var character
export(String, MULTILINE) var dialogue
export(float) var time := 1.0


func execute() -> void:
	Game.dialog.text(character, dialogue, time)
	Game.dialog.connect("completed", self, "_on_dialog_completed", [], CONNECT_ONESHOT)


func _on_dialog_completed() -> void:
	emit_signal("completed")
