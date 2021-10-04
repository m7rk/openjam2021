extends RigidBody2D


# Declare member variables here. Examples:
var WAKE_DIST = 800
# var b = "text"
onready var impact = preload("res://Impact.tscn")

var is_mob = false
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	is_mob = get_parent().name == "Mobs"

func impactSound():
	var v = impact.instance()
	get_parent().add_child(v)
	v.global_position = global_position

# fancy fadeout later
func _on_body_entered(body):
	if(body.name == "Player"):
		body.catch()
		impactSound()
	if(body.name == "Enemy"):
		body.catch()
		impactSound()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(is_mob):
		sleeping = true
		if(WAKE_DIST > abs(get_node("../../Player").global_position.x - global_position.x)):
			sleeping = false
			linear_velocity.x = -200
			linear_velocity.y = 30
