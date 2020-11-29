extends Node

export var character_name : String
export var color : Color
export var sound : AudioStream


func _ready() -> void:
	yield(get_parent(), "ready")
	get_parent().add_profile(name, {
		color = color,
		character_name = character_name,
		sound = sound,
	})
	queue_free()
