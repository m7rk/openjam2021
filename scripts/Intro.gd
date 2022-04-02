extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var t = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(Input.is_action_pressed("close") and t == 3):
		t = 2
		
	if(t<=2):
		t -= delta
		get_node("tr").modulate = Color(1,1,1,2-t)
		get_node("title").volume_db = (t-2)*40
		if(t < 1):
			get_tree().change_scene("res://Fight.tscn")
