extends Node

export(String) var action_up
export(String) var action_down
export(String) var action_left
export(String) var action_right


func get_movement() -> Vector2:
	return Vector2(
		Input.get_action_strength(action_right) - Input.get_action_strength(action_left),
		Input.get_action_strength(action_down) - Input.get_action_strength(action_up)
	)
