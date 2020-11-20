extends Node

signal completed()

export(String) var character
export(String, MULTILINE) var dialogue
export(float) var chars_per_second := 20.0


func execute() -> void:
	Game.dialog.text(character, dialogue, chars_per_second)
	Game.dialog.connect("completed", self, "_on_dialog_completed", [], CONNECT_ONESHOT)


func _on_dialog_completed() -> void:
	emit_signal("completed")
