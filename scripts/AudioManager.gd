extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	if(Progress.progress == 0):
		get_node("Intro").playing = true
	else:
		get_node("Loop").playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!get_node("Intro").playing and not get_node("Loop").playing):
		get_node("Loop").playing = true
