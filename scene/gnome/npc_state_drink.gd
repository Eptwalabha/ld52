extends "res://scene/gnome/npc_state.gd"

var glup_duration : float = 3.0

func enter() -> void:
	super.enter()
	timer = glup_duration

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
		npc.target.drank(1.0)
		npc.fullness += 1
		if npc.fullness == 3:
			emit_signal("finished")
		timer += glup_duration

func away_from_plant() -> void:
	emit_signal("finished")
