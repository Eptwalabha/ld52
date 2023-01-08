class_name WaterSource
extends Area2D

signal emptied

@export var water_volume : int = 5
@export var infinit_volume : bool = false
@export var hint : String = "interact"
@export var can_extract_water : bool = true

func drank(amount: int) -> void:
	if infinit_volume or not can_extract_water:
		return
	water_volume = max(0, water_volume - 1)
	can_extract_water = can_extract_water and water_volume > 0

func extract_water(amount: float) -> float:
	if not can_extract_water:
		return 0.0
	if infinit_volume:
		return amount
	amount = min(water_volume, amount)
	water_volume = max(water_volume - amount, 0.0)
	if water_volume == 0.0:
		can_extract_water = false
		emit_signal("emptied")
	return amount
