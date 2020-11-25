extends Node2D

signal completed()

var _check : PackedScene = preload("res://levels/Savegame.tscn")


func execute() -> void:
	Game.save()

	var flag := _check.instance() as Node2D
	flag.global_position = global_position
	owner.add_child(flag)

	emit_signal("completed")
