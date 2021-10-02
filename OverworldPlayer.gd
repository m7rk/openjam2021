extends KinematicBody2D

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if(Input.is_action_pressed("left")):
		velocity.x = -100
	if(Input.is_action_pressed("right")):
		velocity.x = 100
	if(Input.is_action_pressed("up")):
		velocity.y = -100
	if(Input.is_action_pressed("down")):
		velocity.y = 100
	
	if(Input.is_action_just_pressed("close")):
		get_tree().get_root().get_node("Node2D").transition()
	
	move_and_slide(velocity, Vector2.UP)
