extends Node

signal completed()


func execute() -> void:
	Game.scene.follow_characters()
	emit_signal("completed")
