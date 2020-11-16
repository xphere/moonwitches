extends State

signal completed()

var destination : Vector2

func enter(board: Dictionary) -> void:
	destination = board["destination"] if board.has("destination") else owner.global_position


func update(delta: float, board: Dictionary) -> void:
	var enemy := owner as Enemy

	var target := enemy.search_target()
	if target:
		enemy.chase()

	elif enemy.is_near(destination):
		emit_signal("completed")

	elif enemy.can_walk_straight(destination):
		enemy.walk_towards(destination)

	else:
		enemy.respawn_at(destination)
