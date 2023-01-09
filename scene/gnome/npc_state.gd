class_name State
extends Node

signal changed(state_name)
signal finished

var npc : CharacterBody2D
var timer : float = 0.0
var active_state = false

func enter() -> void:
	active_state = true

func exit() -> void:
	active_state = false

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func near_plant() -> void:
	pass

func away_from_plant() -> void:
	pass
