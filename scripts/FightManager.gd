extends Node2D


var trans_time = 2.1

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("CanvasLayer/Display/AnimationPlayer").play("roundstart")
	get_node("Transitioner/AnimationPlayer").play("endtrans")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	trans_time -= delta
	
	if(get_node("Player").hp <= 0):
		if(trans_time < 0):
			get_node("CanvasLayer/Display/AnimationPlayer").play("roundfinish")
			trans_time = 4
		if(trans_time < 2):
			get_node("Transitioner/AnimationPlayer").play("starttrans")
		if(trans_time < 1):
			 get_tree().reload_current_scene()
