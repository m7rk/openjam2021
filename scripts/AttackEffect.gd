extends AnimatedSprite

var effect_time = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	effect_time -= delta
	modulate = Color(0.8,1,0.8,effect_time / 0.2)
	if(effect_time <= 0):
		queue_free()
