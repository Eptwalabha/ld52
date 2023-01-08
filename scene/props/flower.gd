class_name Flower
extends Node2D

signal died

@export var water_volume : float = 2.0
var alive : bool = true

func _process(delta) -> void:
	water_volume -= delta
	if alive and water_volume < 0.0:
		alive = false
		emit_signal("died")


func _on_area_2d_body_entered(body):
	if body is WaterBubble:
		water_volume += body.damage
		body.pop(global_position)
