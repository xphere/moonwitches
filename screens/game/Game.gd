extends Control

signal paused();
signal unpaused();

var _pause_state := 0

onready var dialog : Dialog = $Dialog
onready var scene : Scene = $Scene


func pause() -> void:
	_pause_state += 1
	if _pause_state == 1:
		emit_signal("paused")
		get_tree().paused = true


func unpause() -> void:
	_pause_state -= 1
	if _pause_state == 0:
		emit_signal("unpaused")
		get_tree().paused = false
