extends Node2D


@onready var player : Player = $player
@onready var flower : Flower = $flower
@onready var player_water_ui : Label = $ui/player
@onready var plant_water_ui : Label = $ui/plant

@onready var Bubble = load("res://scene/water/water_bubble.tscn")
@onready var Splash = load("res://scene/water/water_spash.tscn")

func _ready():
	pass


func _process(delta):
	player_water_ui.text = "%02.1f L" % player.get_water_capacity()
	plant_water_ui.text = "%02.1f L" % flower.water_volume


func _on_flower_died():
	print("game over")


func _on_player_spat(charged_time):
	var amount = player.spit(charged_time)
	var bubble : WaterBubble = Bubble.instantiate()
	bubble.global_transform = player.global_transform
	bubble.apply_impulse(player.get_aim_direction() * 800.0)
	bubble.splashed.connect(_on_bubble_splashed)
	add_child(bubble)
	bubble.water_volume = amount

func _on_bubble_splashed(position):
	var splash : CPUParticles2D = Splash.instantiate()
	splash.global_position = position
	add_child(splash)
	splash.emitting = true
	print("position %s" % position)
