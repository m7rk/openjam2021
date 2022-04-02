extends Node2D


# Declare member variables here.
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Progress.new_game += 1
	get_node("Transitioner/AnimationPlayer").play("endtrans")
	
func process(delta):
	t += delta
	if(t > 15):
		get_tree().change_scene("res://Intro.tscn")
