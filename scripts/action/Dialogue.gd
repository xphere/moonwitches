extends Node

signal completed()

enum Position {
	Bottom = Control.PRESET_BOTTOM_WIDE,
	Top = Control.PRESET_TOP_WIDE,
}

export var character : String
export(String, MULTILINE) var dialogue : String
export var chars_per_second := 20.0
export(Position) var position := Position.Bottom


func execute() -> void:
	Game.dialog.text(character, dialogue, chars_per_second)
	Game.dialog.connect("completed", self, "_on_dialog_completed", [], CONNECT_ONESHOT)
	Game.dialog.set_anchors_and_margins_preset(position, Control.PRESET_MODE_KEEP_SIZE)


func _on_dialog_completed() -> void:
	emit_signal("completed")
