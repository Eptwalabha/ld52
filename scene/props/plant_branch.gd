@tool
class_name PlantBranch
extends Path2D

@onready var line : Line2D = $Line2D

@export var time_start: float = 0.0
@export var growth_speed : float = 100.0
@export var branch_width : float = 0.01 : set = _set_branch_width
@export_range(0.0, 60.0) var time_growing : float = 0.0 : set = _set_time_growing
@export var total_duration : float = 5.0

@export_range(0.0, 1.0) var health : float = 1.0 : set = _set_health
@export var gradient : Gradient = preload("res://resource/images/plant_health_gradient.tres")

var branches : Array[PlantBranch] = []
var step : float = 5.0

func _ready():
	var length : float = curve.get_baked_length()
	total_duration = length / growth_speed

	for child in get_children():
		if child is PlantBranch:
			var child_origin : Vector2 = to_local(child.to_global(child.curve.get_point_position(0)))
			var offset : float = curve.get_closest_offset(child_origin) / length
			child.time_start = offset * total_duration
			prints(child.time_start, child.total_duration)
			branches.push_back(child)

	line.clear_points()
	for i in range(0, int(length / step) + 1):
		line.add_point(curve.sample_baked(i * step))

func _set_time_growing(new_time: float) -> void:
	time_growing = new_time
	var growth : float = clampf(max(0.0, time_growing - time_start) / total_duration, 0.001, 1.0)
	if line is Line2D:
		line.width_curve.set_point_value(1, 0.0)
		line.width_curve.set_point_offset(1, max(0.01, growth))
	for branch in branches:
		branch.time_growing = time_growing

func _set_branch_width(new_width: float) -> void:
	branch_width = clampf(new_width, 0.0, 1.0)
	if line is Line2D:
		line.width_curve.set_point_value(0, max(0.01, branch_width))
		line.width_curve.set_point_offset(0, 0.0)
	for branch in branches:
		var branch_origin: Vector2 = to_local(branch.to_global(branch.curve.get_point_position(0)))
		branch.branch_width = line.width_curve.sample(curve.get_closest_offset(branch_origin) / curve.get_baked_length())

func _set_health(new_health: float) -> void:
	health = clampf(new_health, 0.0, 1.0)
	if line is Line2D:
		line.default_color = gradient.sample(health)
	for branch in branches:
		branch.health = health
