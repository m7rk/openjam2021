extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
var velocity = Vector2.ZERO
var bounces = 2
var team = 1
onready var impact = preload("res://Impact.tscn")

# Called when the node enters the scene tree for the first time.
func impactSound():
	var v = impact.instance()
	get_parent().add_child(v)
	v.global_position = global_position


func _process(delta):
	var body = move_and_collide(velocity * delta)
	if(body):
		if(body.collider.name == "Player" and team == -1):
			body.collider.catch()
			impactSound()
			queue_free()
		if(body.collider.name == "Enemy" and team == 1):
			body.collider.catch()
			impactSound()
			queue_free()
		# bounce
		bounces -= 1
		if(bounces == 0):
			queue_free()
		velocity.y = -velocity.y
		position.y -= 10
	velocity += Vector2(0,10)
