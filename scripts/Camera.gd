extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(Progress.progress == 2):
		global_position.x = 10000
	if(Progress.progress == 3):
		global_position.x = 20000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(get_node("../").trans_time > 0):
		return

	var targ = Vector2(250 + (get_node("../Enemy").global_position.x + get_node("../Player").global_position.x)/2, 250 )
	var offset = abs(targ.x - get_node("../Player").global_position.x)
	
	if(offset > 550 or (get_node("../Enemy").hp <= 0)):
		targ.x = get_node("../Player").global_position.x + 550
	global_position = lerp(global_position,targ,10*delta)
