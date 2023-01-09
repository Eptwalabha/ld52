extends "res://scene/gnome/npc_state.gd"

func enter() -> void:
	super.enter()
	timer = 3.0

func exit() -> void:
	super.exit()

func physics_process(delta) -> void:
	if not npc.is_on_floor():
		npc.velocity.y += npc.gravity * delta

	var delta_x = npc.target.global_position.x - npc.global_position.x
	npc.velocity.x = sign(delta_x) * npc.SPEED
	
	npc.move_and_slide()

func process(delta) -> void:
	timer -= delta
	if timer <= 0.0:
		emit_signal("finished")

func near_plant() -> void:
	emit_signal("finished")
