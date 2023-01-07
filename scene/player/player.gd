class_name Player
extends CharacterBody2D

signal spat(charged_time)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var pivot : Node2D = $pivot
@onready var aim : Node2D = $aim
@onready var anim : AnimationPlayer = $AnimationPlayer

@export var water_max_capacity : int = 100
@export var drinking_speed : float = 150.0
var water_level : float = 0.0
var drinking_curve : Curve = preload("res://scene/player/drinking_speed.tres")

@export var spit_max_charge : float = 3.0
var spitting : bool = false
var spitting_charge: float = 0.0
var spitting_curve : Curve = preload("res://scene/player/spitting.tres")

func _physics_process(delta):

	if spitting:
		var dir = Vector2(
			Input.get_axis("look_left", "look_right"),
			Input.get_axis("look_up", "look_down"))
		if dir.length() > .1:
			aim.rotation = dir.normalized().angle() + PI / 2.0
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("move_left", "move_right")
		if direction != 0 and (pivot.scale.x < 0) == (direction > 0):
			pivot.scale.x *= -1

		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func _process(delta):
	if Input.is_action_pressed("action"):
		drink(delta)

	if Input.is_action_just_pressed("attack"):
		anim.play("hit")
		
	if Input.is_action_just_pressed("charge"):
		start_spit_charge()

	if spitting and Input.is_action_just_released("charge"):
		end_spit_charge()

	if spitting and Input.is_action_pressed("attack"):
		spitting_charge += delta
		if spitting_charge > spit_max_charge:
			end_spit_charge()

func start_spit_charge() -> void:
	spitting = water_level > 0.0
	aim.visible = spitting
	spitting_charge = 0.0

func end_spit_charge() -> void:
	spitting = false
	aim.visible = false
	emit_signal("spat", spitting_charge)

func drink(delta: float) -> void:
	var fullness : float = water_level / 100.0
	var drinking_amount : float = drinking_curve.sample(fullness)
	water_level = min(water_level + delta * drinking_amount * drinking_speed, water_max_capacity)

func spit(charging_time: float) -> float:
	var spit_ratio = spitting_curve.sample(min(charging_time / spit_max_charge, 1.0))
	var spit_amount : float = min(water_level, 10.0 + water_level * spit_ratio)
	water_level = water_level - spit_amount
	return spit_amount

func get_aim_direction() -> Vector2:
	return Vector2.UP.rotated(aim.rotation)

func get_water_capacity() -> float:
	return water_level

func _on_area_2d_area_entered(area):
	pass
