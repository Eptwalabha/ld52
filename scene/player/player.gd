class_name Player
extends CharacterBody2D

signal spat(charged_time)

var SPEED : float = 500.0
const JUMP_VELOCITY = -450.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var pivot : Node2D = $pivot
@onready var aim : Node2D = $aim
@onready var anim : AnimationPlayer = $AnimationPlayer


var fullness : int = 0
var aiming : bool = false

var current_water_source : WaterSource = null

var drinking : bool = false
@export var drink_level_duration : float = .5
var drinking_duration: float = 0.0

func __set_speed() -> void:
	match fullness:
		0, 1: SPEED = 500.0
		2, 3: SPEED = 400.0
		4, 5: SPEED = 300.0
		_: SPEED = 200.0

func __get_bubble_damage() -> float:
	match fullness:
		0: return 0.0
		1, 2: return 20.0
		3, 4: return 30.0
		_: return 50.0

func _physics_process(delta):

	if aiming:
		var dir = Vector2(
			Input.get_axis("look_left", "look_right"),
			Input.get_axis("look_up", "look_down"))
		if dir.length() > .1:
			aim.rotation = dir.normalized().angle() + PI / 2.0
	elif Input.is_action_pressed("action"):
		if not is_on_floor():
			velocity.y += gravity * delta
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("move_left", "move_right")
		if direction != 0 and (pivot.scale.x < 0) == (direction > 0):
			pivot.scale.x *= -1

		if direction and not drinking:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("action"):
		drinking = false
		anim.play("start_drinking")

	if Input.is_action_pressed("action"):
		drink(delta)

	if Input.is_action_just_released("action"):
		if drinking:
			stop_drinking()

	if Input.is_action_just_pressed("attack"):
		anim.play("hit")

	if fullness > 0 and Input.is_action_just_pressed("charge"):
		start_spit_aim()

	if aiming and Input.is_action_just_released("charge"):
		spit()

func start_spit_aim() -> void:
	aiming = true
	aim.visible = true

func can_drink() -> bool:
	return fullness < 6 and \
		current_water_source != null and \
		current_water_source.can_extract_water

func start_drinking() -> void:
	drinking = true
	if not Input.is_action_pressed("action"):
		stop_drinking()
		return

	if not can_drink():
		print("cannot drink")
		anim.play("cannot_drink")
	else:
		gulp(1)
		drinking_duration = 0.0
		anim.play("drink")

func drink(delta: float) -> void:
	if not drinking:
		return
	if not can_drink():
		stop_drinking()
	else:
		drinking_duration += delta
		if drinking_duration > drink_level_duration:
			drinking_duration -= drink_level_duration
			gulp(1)
			if fullness < 6 and can_drink():
				anim.play("drink")
			else:
				stop_drinking()

func gulp(amount: int) -> void:
	fullness += amount
	__update_fullness()
	current_water_source.drank(amount)

func stop_drinking() -> void:
	drinking = false
	anim.play_backwards("stop_drinking")

func spit() -> void:
	aiming = false
	aim.visible = false
	if fullness == 0:
		return
	var bubble_damage : float = __get_bubble_damage()
	fullness -= 1
	__update_fullness()
	emit_signal("spat", bubble_damage)

func get_aim_direction() -> Vector2:
	return Vector2.UP.rotated(aim.rotation)

func get_water_capacity() -> int:
	return fullness

func __update_fullness() -> void:
	__set_speed()

func _on_item_detector_area_entered(_area):
	pass

func _on_water_detector_area_entered(area : WaterSource):
	if area == null:
		pass
	current_water_source = area

func _on_water_detector_area_exited(area):
	if area == current_water_source:
		current_water_source = null
