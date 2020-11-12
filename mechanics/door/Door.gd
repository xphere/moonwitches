tool
extends StaticBody2D


export(NodePath) var _device : NodePath setget _set_device
export(bool) var keep_open := true


func _get_configuration_warning() -> String:
	if not _device or _device.is_empty() or not has_node(_device):
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

	var device := get_node(_device) as Device
	device.connect("activate", self, "_open")
	if not keep_open:
		device.connect("deactivate", self, "_close")
	_close()


func _open() -> void:
	$Sprite.frame = 1
	collision_mask = 0


func _close() -> void:
	$Sprite.frame = 0
	$Collision.disabled = false
	collision_mask = 2 + 4 + 8
