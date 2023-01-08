extends Node

@onready var fade : Fade = $Fade
@onready var story : RichTextLabel = %Story
@onready var timer : Timer = %Story/Timer

func _ready():
	fade.fade_in()

func _on_fade_completed_fade_in():
	timer.start()

func _on_fade_completed_fade_out():
	get_tree().change_scene_to_file("res://scene/game.tscn")

func _on_next_pressed():
	fade.fade_out()

func _on_timer_timeout():
	story.visible_characters += 3
	if story.visible_ratio >= 1.0:
		$Control/Next.visible = true
		timer.stop()
