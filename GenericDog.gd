extends KinematicBody2D

var hp = 0
var velocity = Vector2.ZERO
var gravity = 1000
var movespeed = 1500
var dampen = 10

var input = ""
var cmds = []

func hit(rev):
	velocity.y = -100
	velocity.x = rev * 1000

func do_input(rev, delta):
	if("right" in cmds):
		velocity.x += delta * movespeed * rev
	if("left" in cmds):
		velocity.x -= delta * (movespeed / 2) * rev

func fight(rev):
	if("close" in cmds):
		print("FF")
		get_node("../Enemy").hit(rev)

func apply_forces(delta):
	velocity.x = velocity.x * (1 - (delta * dampen))
	velocity.y += gravity * delta

