extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_node("../Camera2D").global_position / 2 + Vector2(-300,-100)
	for i in get_children():
		if(get_node("../Player").global_position.x - i.global_position.x > 2000):
			# scoot up
			i.global_position.x += (990 * 4)
		if(get_node("../Player").global_position.x - i.global_position.x < -2000):
			# scoot back
			i.global_position.x -= (990 * 4)
