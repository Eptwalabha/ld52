class_name Fade
extends ColorRect

signal completed_fade_in
signal completed_fade_out

@onready var anim : AnimationPlayer = $AnimationPlayer

func _ready():
	visible = true

func fade_in() -> void:
	anim.play("fade_in")

func fade_out() -> void:
	anim.play("fade_out")

func fade_out_complete() -> void:
	emit_signal("completed_fade_out")

func fade_in_complete() -> void:
	emit_signal("completed_fade_in")
