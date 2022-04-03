extends Node2D


# Declare member variables here.
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Progress.new_game += 1
	Progress.progress = 0
	Progress.loop_pos = 0
	get_node("Transitioner/AnimationPlayer").play("endtrans")
	
func _process(delta):
	t += delta
	if(t > 20):
		get_tree().change_scene("res://Intro.tscn")
