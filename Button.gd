extends Device

var _pressing := 0


func _on_body_entered(_body: Node) -> void:
	if _pressing == 0:
		self.state = true
		$Sprite.frame = 1
	_pressing += 1


func _on_body_exited(_body: Node) -> void:
	_pressing -= 1
	if _pressing == 0:
		self.state = false
		$Sprite.frame = 0
