extends Node2D


var trans_time = 2.15

var hittime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Transitioner/AnimationPlayer").play("endtrans")
	if(Progress.progress == 0):
		trans_time += 15
		Progress.progress = 1
		get_node("IntroPlayer").play("Intro")
	
func triggerHitTime():
	hittime = 0.03
	Engine.time_scale = 0.05
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	trans_time -= delta
	hittime -= delta
	
	if(trans_time + delta > 2.1 and trans_time <= 2.1):
		print("TRIG")
		get_node("CanvasLayer/Display/AnimationPlayer").play("roundstart")
	
	if(hittime <= 0):
		Engine.time_scale = 1
	
	if(get_node("Player").hp <= 0):
		if(trans_time < 0):
			get_node("CanvasLayer/Display/AnimationPlayer").play("roundfinish")
			trans_time = 4
		if(trans_time < 2):
			get_node("Transitioner/AnimationPlayer").play("starttrans")
		if(trans_time < 1):
			 get_tree().reload_current_scene()
	
	if(get_node("Player").position.x > 9000):
		trans_time = 4
		get_node("CanvasLayer/Display/AnimationPlayer").play("roundwin")
		if(trans_time < 2):
			get_node("Transitioner/AnimationPlayer").play("starttrans")
		if(trans_time < 1):
			 get_tree().reload_current_scene()

