extends NinePatchRect
class_name Dialog

signal completed();

export(float) var characters_per_second := 6.0

onready var _name := $MarginContainer/HBoxContainer/Name
onready var _text := $MarginContainer/HBoxContainer/Text
onready var _animation := $MarginContainer/Outer/Inner/AnimationPlayer


func _ready() -> void:
	if owner:
		visible = false


func text(name: String, text: String, speed: float = 1.0) -> void:
	_name.text = name
	_text.text = text
	_animation.playback_speed = characters_per_second * speed / text.length();
	_animation.play("Play")
	visible = true


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	emit_signal("completed")
	visible = false
