extends Node2D


# Declare member variables here.

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Transitioner/AnimationPlayer").play("endtrans")
