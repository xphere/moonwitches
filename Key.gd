extends Device


func _on_body_entered(_body: Node) -> void:
	self.state = true
	_hide(self)


func _hide(node: Node) -> void:
	(node as Node2D).hide()
