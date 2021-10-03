extends Node2D


# Declare member variables here. Examples:
# var a = 2
var RAT_SPEED = 200
var RAT_KNOCKBACK = 4000
var WAKEUP = 1000
var hp = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dist = abs(get_node("../../Player").global_position.x - global_position.x)
	if(dist < WAKEUP):
		global_position.x -= delta * RAT_SPEED
		if(get_node("AnimatedSprite").frame == 4):
			get_node("AnimatedSprite").frame = 0
	if(hp < 0):
		queue_free()
	


func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		body.hit(-1, RAT_KNOCKBACK)
		hp -= 1
	else:
		# projectile / boundary hit me!
		hp -= 1
		if(body.name == "Ball" or body.name == "Frisbee"):
			queue_free()
