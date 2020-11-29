extends Node

signal completed()


# Use it to call methods on other nodes when completed
func execute() -> void:
	emit_signal("completed")
