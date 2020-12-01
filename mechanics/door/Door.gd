tool
extends StaticBody2D

signal activate()
signal deactivate()

export var _device : NodePath setget _set_device
export var keep_open := true


func _get_configuration_warning() -> String:
	if owner == null:
		return ""

	if not _device or _device.is_empty():
		return ""

	if not has_node(_device):
		return "Requires a connected device to open it"

	var device := get_node(_device) as Device
	if not device:
		return "Connected node is not a valid Device"

	return ""


func _set_device(path: NodePath) -> void:
	_device = path
	update_configuration_warning()


func _ready() -> void:
	if Engine.editor_hint:
		return

	if _device.is_empty() or not has_node(_device):
		_open()
		return

	var device := get_node(_device) as Device
	if not device:
		return

	device.connect("activate", self, "_on_activate")
	if not keep_open:
		device.connect("deactivate", self, "_on_deactivate")

	_close()


func _open() -> void:
	$Sprite.frame = 1
	$Collision.set_deferred("disabled", true)
	emit_signal("activate")


func _on_activate() -> void:
	_open()
	$Sounds/AnimationPlayer.play("Open")


func _close() -> void:
	$Sprite.frame = 0
	$Collision.set_deferred("disabled", false)
	emit_signal("deactivate")


func _on_deactivate() -> void:
	_close()
	$Sounds/AnimationPlayer.play("Close")
