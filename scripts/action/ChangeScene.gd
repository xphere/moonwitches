extends Node

signal completed()

export(String, FILE, "*.tscn") var next_scene : String


func execute() -> void:
	Game.scene.load(next_scene)
	emit_signal("completed")
