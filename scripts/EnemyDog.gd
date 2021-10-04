extends "res://scripts/GenericDog.gd"

var move_time = 1
var fight_started = false
var dialog_started = false
var dialog_timer = 2

var EASINESS = 0.2

func _physics_process(delta):
	
	if(dialog_started):
		dialog_timer -= delta

	move_time -= delta
	if(move_time < 0):
		var targ = int(rand_range(0,4))
		if(targ == 0 or targ == 1):
			cmds = ["right"]
			move_time = 0.5 + EASINESS
		elif(targ == 2):
			cmds = ["special"]
			move_time = 0.1 + EASINESS
		else:
			cmds = []
			move_time = 0.3 + EASINESS
	
	var dist = abs(global_position.x - get_node("../Player").global_position.x)
	
	if(dist < 190):
		cmds.append("close")
	
	if(dist > 400 && move_time > 0.4):
		cmds.append("ranged")
	
	if(!dialog_started and abs(get_node("../Player").global_position.x - global_position.x) < 600):
		dialog_started = true
		get_node("Dialog").visible = true
	
	if(dialog_timer < 0 and dialog_timer + delta >= 0):
		fight_started = true
		get_node("TalkWall").queue_free()
		get_node("Dialog").visible = false
	
	if(hp <= 0):
		get_node("HEAD").disabled = true
		get_node("BODY").disabled = true
		cmds = []
		
	if(fight_started):
		doInput(-1,delta)
		

	applyForces(delta)
	velocity = move_and_slide(velocity, Vector2.DOWN)
