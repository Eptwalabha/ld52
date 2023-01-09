extends "res://scene/gnome/npc_state.gd"

func enter() -> void:
	super.enter()
	timer = 1.0 + randf()

func exit() -> void:
	super.exit()

func physics_process(delta) -> void:
	if not npc.is_on_floor():
		npc.velocity.y += npc.gravity * delta
	npc.velocity.x = move_toward(npc.velocity.x, 0, npc.SPEED)
	npc.move_and_slide()

func process(delta) -> void:
	timer -= delta
	if timer <= 0.0:
		emit_signal("finished")
