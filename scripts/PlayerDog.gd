extends "res://scripts/GenericDog.gd"


func fetch_inputs():

	if(Input.is_action_pressed("left")):
		cmds.append("left")
	if(Input.is_action_pressed("right")):
		cmds.append("right")
	if(Input.is_action_just_pressed("close")):
		cmds.append("close")
	if(Input.is_action_just_pressed("ranged")):
		cmds.append("ranged")
	if(Input.is_action_just_pressed("special")):
		cmds.append("special")

func _physics_process(delta):
	cmds = []
	fetch_inputs()
	fight(1)
	do_input(1,delta)
	apply_forces(delta)
	velocity = move_and_slide(velocity, Vector2.DOWN)
	
