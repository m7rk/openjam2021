extends Node2D


# Declare member variables here. Examples:
# var a = 2
var BEE_SPEED = 100
var BEE_KNOCKBACK = 200
var WAKEUP = 1000
var DIVE_BOMB_DIST = 300
var can_dive_bomb = false

# Called when the node enters the scene tree for the first time.
func _ready():
	can_dive_bomb = (global_position.y == 300)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dist = abs(get_node("../../Player").global_position.x - global_position.x)
	if(can_dive_bomb and dist < DIVE_BOMB_DIST):
		global_position.x -= delta * 2 *  BEE_SPEED
		global_position.y += delta * BEE_SPEED
		if(get_node("AnimatedSprite").frame == 9):
			get_node("AnimatedSprite").frame = 6
			
	elif(dist < WAKEUP):
		global_position.x -= delta * BEE_SPEED
		if(get_node("AnimatedSprite").frame == 4):
			get_node("AnimatedSprite").frame = 0
	

func hit():
	queue_free()

func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		body.hit(-1,BEE_KNOCKBACK)
		queue_free()
	else:
		# projectile / boundary hit me!
		queue_free()
		if(body.name == "Ball" or body.name == "Frisbee"):
			body.queue_free()
