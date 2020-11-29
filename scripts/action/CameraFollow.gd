extends Node

signal completed()

export var follow : NodePath = "."
export var restore_after_parent_completes := false


func _ready() -> void:
	if restore_after_parent_completes:
		get_parent().connect("completed", self, "_restore")


func execute() -> void:
	Game.scene.follow(get_node(follow))
	emit_signal("completed")


func _restore() -> void:
	Game.scene.follow_characters()
