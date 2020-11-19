extends NinePatchRect
class_name Dialog

signal completed();

onready var _name := $MarginContainer/HBoxContainer/Name
onready var _text := $MarginContainer/HBoxContainer/Text
onready var _animation := $MarginContainer/Outer/Inner/AnimationPlayer


func _ready() -> void:
	if owner:
		visible = false


func text(name: String, text: String, time: float) -> void:
	_name.text = name
	_text.text = text
	_animation.playback_speed = 1.0 / time;
	_animation.play("Play")
	visible = true


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	call_deferred("_completed")
	visible = false


func _completed() -> void:
	emit_signal("completed")
