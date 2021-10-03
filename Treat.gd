extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("treatwobble")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(global_position.distance_to(get_node("../../Player").global_position) < 50):
		queue_free()
		get_node("../../Player").heal()
