extends Node

signal triggered()

onready var _trigger := $trigger
onready var _filter := $filter


func _ready() -> void:
	_trigger.connect("triggered", self, "_on_trigger")


func _on_trigger() -> void:
	if _filter.filter():
		emit_signal("triggered")
