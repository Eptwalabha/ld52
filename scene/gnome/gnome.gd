class_name Gnome
extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var fullness : int = 0
var near_flower: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var target : Flower

var current_state : State
var states : Dictionary = {}

func _ready():
	for state in $states.get_children():
		if state is State:
			state.npc = self
			state.changed.connect(_on_state_changed)
			state.finished.connect(_on_state_finished.bind(state))
			states[state.name] = state
	replace_state("idle")

func _physics_process(delta) -> void:
	current_state.physics_process(delta)

func _process(delta) -> void:
	current_state.process(delta)

func drink() -> void:
	pass

func replace_state(new_state: String) -> void:
	if current_state is State:
		current_state.exit()
	current_state = states[new_state]
	current_state.enter()

func _on_state_changed(new_state: String) -> void:
	replace_state(new_state)

func _on_state_finished(state: State) -> void:
	match state.name:
		"jump": replace_state("walk")
		"walk", "escape":
			var new_state : String = ["walk", "idle", "jump"].pick_random()
			if near_flower:
				new_state = "drink"
			replace_state(new_state)
		"idle": replace_state(["walk", "jump"].pick_random())
		"drink": replace_state("leave")
		"leave": queue_free()

func _on_plant_detector_area_entered(area):
	if area.owner is Flower:
		near_flower = true
		current_state.near_plant()

func _on_plant_detector_area_exited(area):
	if area.owner is Flower:
		near_flower = false
		current_state.away_from_plant()
