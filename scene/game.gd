extends Node2D

@onready var player : Player = %player
@onready var flower : Flower = %flower
@onready var sky : SunMoon = %SunMoon
@onready var debug_infos : RichTextLabel = $ui/infos
@onready var foreground : ParallaxLayer = $parallax/foreground

@onready var Bubble = load("res://scene/water/water_bubble.tscn")
@onready var Splash = load("res://scene/water/water_spash.tscn")

var playing : bool = true

func _process(delta):
	debug_infos.text = "[color=green]player[/color]: %d L\n[color=green]plant[/color]: %02.1fL\n[color=green]heat[/color]: %1.3f" % \
		[player.get_water_capacity(), flower.water_volume, sky.get_sun_intensity()]
	if playing:
		sky.process(delta)
		flower.dry(delta, sky.get_sun_intensity())

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
	get_tree().change_scene_to_file("res://scene/story/game_over_win.tscn")

func _on_sun_moon_new_cycle(id):
	pass

func _on_sun_moon_harvest_moon():
	playing = false
	get_tree().change_scene_to_file("res://scene/story/game_over_win.tscn")
