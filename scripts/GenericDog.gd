extends KinematicBody2D

var frisbee = preload("res://frisbee/frisbee.tscn")


var hp = 100
var velocity = Vector2.ZERO
var input = ""
var cmds = []

# which attack are we charging?
var charge_command = ""
# how long have we charged it for?
var charge_time = 0

# no attacks or charging allowed during cooldown
var cooldown = 0
# which attack did we just execute?
var attack_executed = ""

var time_elapsed = 0
var last_inputs = []
var last_l_depress = 0
var last_r_depress = 0

# consts
var GRAVITY = 1000
var MOVESPEED = 2500
var DAMPEN_FACTOR = 10

var CLOSE_ATTACK_LAUNCH = 0.5
var CLOSE_ATTACK_COOLDOWN = 0.7
var CLOSE_ATTACK_VEL_BOOST = 700
var CLOSE_ATTACK_RANGE = 200
var CLOSE_ATTACK_DAMAGE = 20

var RANGED_CHARGE = 0.5
var RANGED_COOLDOWN = 0.5
var RANGED_LAUNCH = 0.3
var RANGED_ATTACK_DAMAGE = 15

var FRISBEE_SPEED_X = 300
var FRISBEE_SPEED_Y = 150

var BACKUP_SPEED_RATIO = 0.7

var DASH_DETECTION_TIME = 0.1
var DASH_VELOCITY = 700
var DASH_COOLDOWN = 0.3
var DASH_COST = 3

func hit(rev):
	velocity.y = -200
	velocity.x = rev * 2500
	hp -= CLOSE_ATTACK_DAMAGE
	
func catch():
	hp -= RANGED_ATTACK_DAMAGE
	# launch catch animation.

func checkForDash(rev):
		# check for dash
	if("right" in last_inputs and not "right" in cmds):
		last_r_depress = time_elapsed
	
	if("left" in last_inputs and not "left" in cmds):
		last_l_depress = time_elapsed
		
	if("right" in cmds and time_elapsed - last_r_depress < DASH_DETECTION_TIME):
		cooldown = DASH_COOLDOWN
		hp -= DASH_COST
		velocity.x += DASH_VELOCITY * rev
		
	if("left" in cmds and time_elapsed - last_l_depress < DASH_DETECTION_TIME):
		cooldown = DASH_COOLDOWN
		hp -= DASH_COST
		velocity.x -= (DASH_VELOCITY * BACKUP_SPEED_RATIO) * rev

func doInput(rev, delta):
	if(get_node("../").trans_time  > 0):
		return
	
	time_elapsed += delta
	
	# cancel move if holding fight keys, or in cooldown
	if("close" in cmds or "ranged" in cmds or "special" in cmds or cooldown > 0):
		cmds.erase("left")
		cmds.erase("right")
	
	checkForDash(rev)
	
	last_inputs = cmds
	

	cooldown -= delta
	tryAttacks(rev,delta)
	
	if(charge_command == "ranged" and charge_time > RANGED_CHARGE):
		get_node("AnimatedSprite").modulate = Color(1,1,0)
	else:
		get_node("AnimatedSprite").modulate = Color(1,1,1)
	
	
	if("right" in cmds):
		velocity.x += delta * MOVESPEED * rev
	if("left" in cmds):
		velocity.x -= delta * (MOVESPEED * BACKUP_SPEED_RATIO) * rev


func tryCloseAttack(rev, delta):
	if(attack_executed == "close" and cooldown > CLOSE_ATTACK_LAUNCH and cooldown - delta <= CLOSE_ATTACK_LAUNCH):
		velocity.x += CLOSE_ATTACK_VEL_BOOST * rev
		# hit them during the pounce frame
		var dist = abs(global_position.x - get_node("../Player").global_position.x)
		if(rev == 1):
			dist = abs(global_position.x - get_node("../Enemy").global_position.x)
		if(dist < CLOSE_ATTACK_RANGE and rev == 1):
			get_node("../Enemy").hit(rev)
		if(dist < CLOSE_ATTACK_RANGE and rev == -1):
			get_node("../Player").hit(rev)
			
	# put in an order to execute "close" attack
	if("close" in cmds and cooldown < 0):
		cooldown = CLOSE_ATTACK_COOLDOWN
		attack_executed = "close"
		charge_command = ""
		return true
	return false

func tryRangedAttack(rev, delta):
	if("ranged" in cmds):
		if(charge_command == ""):
			charge_command = "ranged"
		charge_time += delta
		return true
	else:
		if(charge_command == "ranged" and charge_time > RANGED_CHARGE):
			var v = frisbee.instance()
			get_node("../Projectiles").add_child(v)
			v.global_position = global_position + Vector2(rev * 90,-50)
			v.linear_velocity = Vector2(rev * FRISBEE_SPEED_X,-FRISBEE_SPEED_Y)
			charge_command = ""
			charge_time = 0
			return true
	return false

func tryAttacks(rev, delta):
	# short circuit lmoa
	return tryCloseAttack(rev, delta) || tryRangedAttack(rev, delta)

func applyForces(delta):
	velocity.x = velocity.x * (1 - (delta * DAMPEN_FACTOR))
	velocity.y += GRAVITY * delta

