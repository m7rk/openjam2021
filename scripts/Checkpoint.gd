extends AnimatedSprite



var CHECKPOINT_DIST = 20
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not active and abs(get_node("../../Player").global_position.x - global_position.x) < CHECKPOINT_DIST):
		Progress.progress = int(name)
		active = true
	if(not active):
		if(frame == 2):
			frame = 0
	elif(frame == 0):
			frame = 2
