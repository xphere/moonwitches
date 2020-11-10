extends Device


var _total := 0
var _active := 0


func _ready() -> void:
	for child in get_children():
		if not child is Device:
			continue
		_total += 1
		(child as Device).connect("activate", self, "_on_child_activate")
		(child as Device).connect("deactivate", self, "_on_child_deactivate")


func _on_child_activate() -> void:
	_active += 1
	if _active == _total:
		self.state = true


func _on_child_deactivate() -> void:
	if _active == _total:
		self.state = false
	_active -= 1
