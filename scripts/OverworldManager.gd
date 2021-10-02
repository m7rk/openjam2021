extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Transitioner/AnimationPlayer").play("endtrans")

func do_anim_finished(string):
	get_tree().change_scene("res://Fight.tscn")

func transition():
	get_node("Transitioner/AnimationPlayer").play("starttrans")
	get_node("Transitioner/AnimationPlayer").connect("animation_finished", self, "do_anim_finished")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
