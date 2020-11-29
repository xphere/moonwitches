extends TileMap

export var level : NodePath


func _ready() -> void:
	var _level := get_node(level) as TileMap

	for cell in get_used_cells():
		var tile_index := get_cellv(cell)
		var tile_name := tile_set.tile_get_name(tile_index)
		if not has_node(tile_name):
			print("Can't find node for tile name %s" % tile_name)
			continue

		var placeholder := get_node(tile_name) as InstancePlaceholder
		if not placeholder:
			print("Can't find placeholder for tile name %s" % tile_name)
			continue

		# Clear this cell in the top level
		if _level:
			_level.set_cellv(cell, INVALID_CELL)

		var node := placeholder.create_instance(false) as Node2D
		node.position = map_to_world(cell)
		node.visible = true

		if is_cell_transposed(cell.x, cell.y):
			node.get_node("Sprite").rotation_degrees = 90.0
		if is_cell_x_flipped(cell.x, cell.y):
			(node.get_node("Sprite") as Sprite).flip_h = true
		if is_cell_y_flipped(cell.x, cell.y):
			(node.get_node("Sprite") as Sprite).flip_v = true

		remove_child(node)
		_level.add_child(node)

	queue_free()
