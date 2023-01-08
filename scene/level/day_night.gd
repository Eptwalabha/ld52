class_name SunMoon
extends Node2D

signal new_cycle(id)

@onready var pivot : Node2D = $pivot
@onready var moon : Sprite2D = $pivot/moon
@onready var sun : Sprite2D = $pivot/sun
@onready var shader : Material = $sky.material
@onready var moon_shader : Material = moon.material

@export var day_duration : float = 120.0
@export var nbr_days : float = 10;

var current_cycle : int = 0
var cycle_speed : float = 0.0
var t : float = 0.;
var delta_t : float = 0.;

func _ready():
	cycle_speed = TAU / day_duration
	t = nbr_days * day_duration

func _process(delta):
	delta_t += delta
	pivot.rotation += delta * cycle_speed
	sun.rotation -= delta * cycle_speed
	moon.rotation -= delta * cycle_speed
	if pivot.rotation > TAU:
		current_cycle += 1
		pivot.rotation -= TAU
		emit_signal("new_cycle", current_cycle)
	moon_shader.set_shader_parameter("progression", delta_t / t)
	shader.set_shader_parameter("time", pivot.rotation / TAU)
