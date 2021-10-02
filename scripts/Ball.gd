extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	pass # Replace with function body.

func _process(delta):
	var body = move_and_collide(velocity * delta)
	if(body):
		if(body.collider.name == "Player"):
			body.collider.catch()
			queue_free()
		if(body.collider.name == "Enemy"):
			body.collider.catch()
			queue_free()
		velocity.y = -velocity.y
		position.y -= 10
	velocity += Vector2(0,10)
