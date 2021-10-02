extends "res://scripts/GenericDog.gd"


func fetchInputs():

	if(Input.is_action_pressed("left")):
		cmds.append("left")
	if(Input.is_action_pressed("right")):
		cmds.append("right")
	if(Input.is_action_pressed("close")):
		cmds.append("close")
	if(Input.is_action_pressed("ranged")):
		cmds.append("ranged")
	if(Input.is_action_pressed("special")):
		cmds.append("special")

func _physics_process(delta):
	cmds = []
	fetchInputs()
	doInput(1,delta)
	applyForces(delta)
	velocity = move_and_slide(velocity, Vector2.DOWN)
	
