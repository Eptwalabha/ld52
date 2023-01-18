class_name NPC
extends CharacterBody2D

signal start_dialog

@onready var dialog_label : RichTextLabel = %Dialog
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	dialog_label.visible = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_area_2d_body_entered(player: Player):
	if player == null:
		return
	emit_signal("start_dialog")
	dialog_label.visible = true
	var t : Tween = get_tree().create_tween()
	dialog_label.visible_ratio = 0.0
	t.tween_property(dialog_label, "visible_ratio", 1.0, 0.5)
