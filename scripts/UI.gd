extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var full = preload("res://ui/health.png")
onready var empty = preload("res://ui/unhealth.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	get_node("Line/Marker").anchor_left = 0.05 + (get_node("../Player").global_position.x / 30000) * 0.9
	
	var ctr = 0
	for i in get_node("Player").get_children():
		if (ctr < get_node("../Player").hp):
			i.texture = full
		else:
			i.texture = empty
		ctr += 1

	ctr = 0
	for i in get_node("Enemy").get_children():
		i.visible = (get_node("../Enemy").fight_started)

		if (ctr < get_node("../Enemy").hp):
			i.texture = full
		else:
			i.texture = empty
		ctr += 1
