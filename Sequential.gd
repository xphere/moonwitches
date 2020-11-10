extends Behaviour

export(bool) var loop := true
export(bool) var free_after_finish := true
export(bool) var autoplay_if_root := true

var yielding : GDScriptFunctionState
var next_loop : bool


func _ready() -> void:
	if not autoplay_if_root:
		return
	if not get_parent():
		return
	if get_parent() is Behaviour:
		return
	apply()


func apply() -> void:
	next_loop = loop
	while true:
		var count := 0
		for child in get_children():
			var step := child as Behaviour
			if not (step and step.is_inside_tree()):
				continue
			count += 1
			yielding = step.apply()
			yield(yielding, "completed")
			yielding = null
		if count == 0 or not next_loop:
			break
	if free_after_finish:
		queue_free()


func stop() -> void:
	next_loop = false
	if yielding:
		yielding.unreference()
		yielding = null
