extends Node

signal triggered()


func _ready() -> void:
	Game.scene.connect("scene_ready", self, "_on_scene_ready")


func _on_scene_ready(_scene: Node) -> void:
	emit_signal("triggered")
