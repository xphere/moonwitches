extends Camera2D


var _following := []


func follow(following: Array) -> void:
	_following = []
	for node in following:
		if node as Node2D:
			_following.push_back(node)


func _process(_delta) -> void:
	var _position = Vector2.ZERO
	for node in _following:
		_position += (node as Node2D).position
	position = _position / _following.size()
