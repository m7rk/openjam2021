extends Node2D


# Declare member variables here. Examples:
# var a = 2
var rat_speed = 150
var RAT_KNOCKBACK = 2000
var WAKEUP = 1000
var hp = 2

var MAXVEL = 150
var vel = 150
var accel = 300
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dist = abs(get_node("../../Player").global_position.x - global_position.x)

	if(vel < MAXVEL):
		vel += accel * delta
	vel = min(vel,MAXVEL)
	if(hp == 1):
		vel = min(vel,MAXVEL/2)
	
	if(dist < WAKEUP):
		global_position.x -= delta * vel
		if(get_node("AnimatedSprite").frame == 4):
			get_node("AnimatedSprite").frame = 0
	if(hp <= 0):
		queue_free()
	
func hit():
	hp -= 1
	vel = - 2 * MAXVEL
	global_position.x += 30

func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		body.hit(-1, RAT_KNOCKBACK)
		hit()
	else:
		# projectile / boundary hit me!
		hp -= 1
		if(body.name == "Ball" or body.name == "Frisbee"):
			body.queue_free()
