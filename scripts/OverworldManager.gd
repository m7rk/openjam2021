extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Transitioner/AnimationPlayer").play("endtrans")

func doAnimFinished(string):
	get_tree().change_scene("res://Fight.tscn")

func transition():
	get_node("Transitioner/AnimationPlayer").play("starttrans")
	get_node("Transitioner/AnimationPlayer").connect("animation_finished", self, "doAnimFinished")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
