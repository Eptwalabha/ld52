class_name WaterBubble
extends CharacterBody2D

signal splashed(position)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var damage : float = 20.0

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	var col = get_last_slide_collision()
	if col != null:
		pop(col.get_position())

func pop(pos: Vector2) -> void:
	emit_signal("splashed", pos)
	queue_free()

func apply_impulse(v: Vector2) -> void:
	velocity += v
