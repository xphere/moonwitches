extends Node

export var character_name : String
export var color : Color


func _ready() -> void:
	yield(get_parent(), "ready")
	get_parent().config(name, color, character_name)
	queue_free()
