extends Control

signal paused()
signal unpaused()

var _pause_state := 0

onready var dialog := $Dialog as Dialog
onready var scene := $Scene as Scene
onready var transition := $Transition as Transition


func pause() -> void:
	_pause_state += 1
	if _pause_state == 1:
		emit_signal("paused")


func unpause() -> void:
	_pause_state -= 1
	if _pause_state == 0:
		emit_signal("unpaused")


func is_paused() -> bool:
	return _pause_state > 0
