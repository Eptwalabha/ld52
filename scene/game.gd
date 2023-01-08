extends Node2D


@onready var player : Player = %player
@onready var flower : Flower = %flower
@onready var player_water_ui : Label = $ui/player
@onready var plant_water_ui : Label = $ui/plant
@onready var foreground : ParallaxLayer = $parallax/foreground

@onready var Bubble = load("res://scene/water/water_bubble.tscn")
@onready var Splash = load("res://scene/water/water_spash.tscn")

func _process(delta):
	player_water_ui.text = "%02.1f L" % player.get_water_capacity()
	plant_water_ui.text = "%02.1f L" % flower.water_volume


func _on_player_spat(damage):
	var bubble : WaterBubble = Bubble.instantiate()
	bubble.splashed.connect(_on_bubble_splashed)
	foreground.add_child(bubble)
	bubble.global_transform = player.global_transform
	bubble.apply_impulse(player.get_aim_direction() * 800.0)
	bubble.damage = damage

func _on_bubble_splashed(position):
	var splash : CPUParticles2D = Splash.instantiate()
	foreground.add_child(splash)
	splash.global_position = position
	splash.emitting = true


func _on_flower_died():
	print("game over")

func _on_sun_moon_new_cycle(id):
	print("cycle %s" % id)
