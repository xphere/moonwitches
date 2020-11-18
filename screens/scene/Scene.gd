extends CanvasItem
class_name Scene

signal load_started();
signal load_finished();
signal scene_created(scene);


func load(path: String) -> void:
	emit_signal("load_started")
	var packedScene := ResourceLoader.load(path, "PackedScene") as PackedScene
	emit_signal("load_finished")
	var instance := packedScene.instance()
	emit_signal("scene_created", instance)
