extends Node

signal completed()

export(String, FILE, "*.tscn") var next_scene


func execute() -> void:
	Game.scene.load(next_scene)
	emit_signal("completed")
