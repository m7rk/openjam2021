extends KinematicBody2D

var frisbee = preload("res://frisbee/frisbee.tscn")


var hp = 100
var velocity = Vector2.ZERO
var gravity = 1000
var movespeed = 1500
var dampen = 10

var input = ""
var cmds = []

func hit(rev):
	velocity.y = -100
	velocity.x = rev * 1000
	
func catch():
	hp -= 10

func do_input(rev, delta):
	if("right" in cmds):
		velocity.x += delta * movespeed * rev
	if("left" in cmds):
		velocity.x -= delta * (movespeed / 2) * rev

func fight(rev):
	if("close" in cmds):
		if(abs(global_position.x - get_node("../Enemy").global_position.x) < 200):
			get_node("../Enemy").hit(rev)

	if("ranged" in cmds):
		var v = frisbee.instance()
		get_node("../Projectiles").add_child(v)
		v.global_position = global_position + Vector2(rev * 100,-60)
		v.linear_velocity = Vector2(rev * 200,-60)

func apply_forces(delta):
	velocity.x = velocity.x * (1 - (delta * dampen))
	velocity.y += gravity * delta

