extends Node

signal completed()

export(NodePath) var follow : NodePath
export(bool) var recover_on_remove := false


func execute() -> void:
	Game.scene.follow(get_node(follow))
	emit_signal("completed")


func _exit_tree() -> void:
	if recover_on_remove:
		Game.scene.follow_characters()
