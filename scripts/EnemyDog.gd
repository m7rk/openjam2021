extends "res://scripts/GenericDog.gd"

var move_time = 1

func _physics_process(delta):
	move_time -= delta
	if(move_time < 0):
		var targ = int(rand_range(0,3))
		if(targ == 0):
			cmds = ["right"]
			move_time = 1
		elif(targ == 1):
			cmds = ["left"]
			move_time = 1
		else:
			cmds = []
			move_time = 0.5

	do_input(-1,delta)
	apply_forces(delta)
	velocity = move_and_slide(velocity, Vector2.DOWN)
