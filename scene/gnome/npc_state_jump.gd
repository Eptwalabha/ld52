extends "res://scene/gnome/npc_state.gd"

var has_jumped : bool = false

func enter() -> void:
	super.enter()
	has_jumped = false

func exit() -> void:
	super.exit()

func physics_process(delta) -> void:
	if npc.is_on_floor():
		if has_jumped:
			emit_signal("finished")
		else:
			has_jumped = true
			npc.velocity.y = npc.JUMP_VELOCITY
			npc.velocity.x = sign(npc.target.global_position.x - npc.global_position.x) * npc.SPEED
	else:
		npc.velocity.y += npc.gravity * delta
	npc.move_and_slide()
