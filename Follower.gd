extends Position2D

var distance : float
var parent_position : Vector2


func _ready() -> void:
	distance = position.length()
	parent_position = get_parent().global_position


func _process(_delta: float) -> void:
	var new_parent_position = get_parent().global_position
	if new_parent_position == parent_position:
		return

	position = lerp(
		position,
		(parent_position - new_parent_position).normalized() * distance,
		0.75 * 60.0 * _delta
	)
	parent_position = new_parent_position
