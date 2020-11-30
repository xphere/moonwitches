extends Control

signal paused()
signal unpaused()
signal saved()
signal restored()

var _pause_state := 0
var _saved_game := {}

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


func save() -> void:
	_saved_game = {}
	for node in get_tree().get_nodes_in_group("restorable"):
		var instance_id := (node as Object).get_instance_id()
		_saved_game[instance_id] = node.save()
	emit_signal("saved")


func restore() -> void:
	for instance_id in _saved_game.keys():
		var instance := instance_from_id(instance_id)
		if instance:
			instance.restore(_saved_game[instance_id])
		else:
			_saved_game.erase(instance_id)
	emit_signal("restored")


func clear() -> void:
	_saved_game = {}
