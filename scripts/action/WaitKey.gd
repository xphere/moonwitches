extends Node

signal completed()

func _ready() -> void:
	set_process_input(false)


func execute() -> void:
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		emit_signal("completed")
