extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	connect("body_entered", self, "_on_body_entered")

# fancy fadeout later
func _on_body_entered(body):
	$Label.text = "u wanna tussle m8"
	get_node("../../Player/Camera2D").zoom = Vector2(0.4,0.4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
