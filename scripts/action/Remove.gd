extends Node


func _ready() -> void:
	var parent := get_parent()
	parent.connect("completed", parent, "queue_free")
