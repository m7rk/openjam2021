extends Node2D


# Declare member variables here. Examples:
# var a = 2
var BEE_SPEED = 100
var BEE_KNOCKBACK = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x -= delta * BEE_SPEED
	if(get_node("AnimatedSprite").frame == 4):
		get_node("AnimatedSprite").frame = 0


func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		body.hit(-1,BEE_KNOCKBACK)
		queue_free()
