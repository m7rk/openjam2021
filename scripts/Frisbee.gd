extends RigidBody2D


# Declare member variables here. Examples:
var WAKE_DIST = 800
# var b = "text"

var is_mob = false
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	is_mob = get_parent().name == "Mobs"

# fancy fadeout later
func _on_body_entered(body):
	if(body.name == "Player"):
		body.catch()
	if(body.name == "Enemy"):
		body.catch()
	queue_free()
	
func _on_area_entered(body):
	if("Mob" in body.get_parent().name):
		body.name.get_parent().queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(is_mob):
		sleeping = true
		if(WAKE_DIST > abs(get_node("../../Player").global_position.x - global_position.x)):
			sleeping = false
			linear_velocity.x = -200
			linear_velocity.y = 30
