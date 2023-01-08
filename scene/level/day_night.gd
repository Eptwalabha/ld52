class_name SunMoon
extends Node2D

signal new_cycle(id)

@onready var pivot : Node2D = $pivot
@onready var moon : Sprite2D = $pivot/moon
@onready var sun : Sprite2D = $pivot/sun

@export var cycle_duration : float = 120.0

var current_cycle : int = 0
var cycle_speed : float = 0.0

func _ready():
	cycle_speed = TAU / cycle_duration


func _process(delta):
	pivot.rotation += delta * cycle_speed
	sun.rotation -= delta * cycle_speed
	moon.rotation -= delta * cycle_speed
	if pivot.rotation > TAU:
		current_cycle += 1
		pivot.rotation -= TAU
		emit_signal("new_cycle", current_cycle)
