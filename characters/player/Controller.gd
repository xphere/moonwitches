extends Node

export var action_up : String
export var action_down : String
export var action_left : String
export var action_right : String


func get_movement() -> Vector2:
	return Vector2(
		Input.get_action_strength(action_right) - Input.get_action_strength(action_left),
		Input.get_action_strength(action_down) - Input.get_action_strength(action_up)
	).normalized()
