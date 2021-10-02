extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")

# fancy fadeout later
func _on_body_entered(body):
	if(body.name == "Player"):
		body.catch()
	if(body.name == "Enemy"):
		body.catch()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
