extends "res://scripts/GenericDog.gd"

var move_time = 1

func _physics_process(delta):
	
	move_time -= delta
	if(move_time < 0):
		var targ = int(rand_range(0,4))
		if(targ == 0 or targ == 1):
			cmds = ["right"]
			move_time = 0.5
		elif(targ == 2):
			cmds = ["left"]
			move_time = 0.5
		else:
			cmds = []
			move_time = 0.3
	
	var dist = abs(global_position.x - get_node("../Player").global_position.x)
	
	if(dist < 190):
		cmds.append("close")
	
	if(dist > 400 && move_time > 0.4):
		cmds.append("ranged")
		
	doInput(-1,delta)
	applyForces(delta)
	velocity = move_and_slide(velocity, Vector2.DOWN)
