extends "res://scripts/GenericDog.gd"

var move_time = 1
var fight_started = false
var dialog_started = false
var dialog_timer = 2

var EASINESS = 0.6
var dialogue = "Another dog! Finally,\n someone I can play\nruff with."

var killtimer = 3

func _ready():
	if(Progress.progress == 3):
		respawn()

func respawn():
	global_position.x = 28000
	global_position.y = 250
	EASINESS = 0.4
	hp = 4
	fight_started = false
	dialog_started = false
	dialog_timer = 2
	killtimer = 3
	get_node("TalkWall").layers = 4
	#layer 3 (1)(2)(4)
	
	dialogue = "How are those bees\ntasting, eh?"
	
	get_node("Dialog").visible = true
	get_node("TalkWall").visible = true
	
	get_node("HEAD").disabled = false
	get_node("BODY").disabled = false

func _physics_process(delta):
	
	if(dialog_started):
		dialog_timer -= delta

	move_time -= delta
	if(move_time < 0):
		var targ = int(rand_range(0,7))
		if(targ == 0 or targ == 1):
			cmds = ["right"]
			move_time = 0.5 + EASINESS
		elif(targ == 2):
			cmds = ["special"]
			move_time = 0.1 + EASINESS
		else:
			cmds = []
			move_time = 0.6 + EASINESS
	
	var dist = abs(global_position.x - get_node("../Player").global_position.x)
	
	if(dist < 210):
		cmds.append("close")
	
	if(dist > 400 && move_time > 0.4):
		cmds.append("ranged")
	else:
		cmds.erase("ranged")
	
	if(!dialog_started and abs(get_node("../Player").global_position.x - global_position.x) < 600):
		dialog_started = true
		get_node("Dialog").visible = true
		get_node("Dialog/Label").text = dialogue
	
	if(dialog_timer < 0 and dialog_timer + delta >= 0):
		fight_started = true
		get_node("TalkWall").layers = 0#layer 3 (1)(2)(4_
		get_node("Dialog").visible = false
		get_node("Dialog/Label").text = ""
	
	if(hp <= 0):
		killtimer -= delta
		if(killtimer < 0 and Progress.progress < 3):
			print("respawn")
			respawn()
			return
		get_node("HEAD").disabled = true
		get_node("BODY").disabled = true
		cmds = []
		
	if(fight_started):
		doInput(-1,delta)
		

	applyForces(delta)
	velocity = move_and_slide(velocity, Vector2.DOWN)
