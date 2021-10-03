extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var targ = Vector2((get_node("../Enemy").global_position.x + get_node("../Player").global_position.x)/2, 250 )
	var offset = targ.x - get_node("../Player").global_position.x
	
	if(offset > 250):
		targ.x = get_node("../Player").global_position.x + 250
	global_position = lerp(global_position,targ,10*delta)
