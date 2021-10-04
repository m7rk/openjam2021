extends KinematicBody2D

var frisbee = preload("res://frisbee/frisbee.tscn")
var ball = preload("res://ball/ball.tscn")

var hp = 4
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

var stamina = 100

var time_elapsed = 0
var last_inputs = []
var last_l_depress = 0
var last_r_depress = 0

var attack_consumed = false

var damagefx = preload("res://Hit.tscn")

var movefx = preload("res://MoveEffect.tscn")

# consts
const GRAVITY = 1000
const MOVESPEED = 2500
const DAMPEN_FACTOR = 7

const CLOSE_ATTACK_HIT = 0.4
const CLOSE_ATTACK_LAUNCH = 0.5
const CLOSE_ATTACK_COOLDOWN = 0.7
const CLOSE_ATTACK_VEL_BOOST = 700
const CLOSE_ATTACK_KNOCKBACK = 800

const POUNCE_ATTACK_HIT = 0.2
const POUNCE_ATTACK_LAUNCH = 0.5
const POUNCE_ATTACK_COOLDOWN = 1.7
const POUNCE_ATTACK_VEL_BOOSTX = 2300
const POUNCE_ATTACK_VEL_BOOSTY = -300
const POUNCE_ATTACK_KNOCKBACK = 1200

const RANGED_ATTACK_HIT = 0.5
const RANGED_CHARGE_ONE = 0.1
const RANGED_CHARGE_TWO = 0.5
const RANGED_COOLDOWN = 0.8

const FRISBEE_SPEED_X = 300
const FRISBEE_SPEED_Y = 150

const BALL_SPEED_X = 100
const BALL_SPEED_Y = 400

const BACKUP_SPEED_RATIO = 0.5

const DASH_DETECTION_TIME = 0.1
const DASH_VELOCITY = 2000
const DASH_COOLDOWN = 0.4
const DASH_STAMINA = 60

const STAMINA_REGEN = 50

const VEL_ANIM_THRESH = 20

var moveEffectCtr = 0

var hurtTime = 0

func addMoveEffect(pos):
	moveEffectCtr -= 1
	if(moveEffectCtr < 0):
		var g = movefx.instance()
		get_node("../MoveEffects").add_child(g)
		g.global_position = pos
		g.frames = getActiveAnim().frames
		g.frame = getActiveAnim().frame
		moveEffectCtr = 3

func hit(rev, knockback):
	velocity.y = -200
	velocity.x = rev * knockback
	hp -= 1
	get_node("HitHurt").play()
	hurtTime = 0.04
	get_node("../").triggerHitTime()
	
func catch():
	hp -= 1
	hurtTime = 0.04
	get_node("../").triggerHitTime()
	get_node("HitHurt").play()
	# launch catch animation.

func _ready():
	setAnim("Idle",1)

func checkForDash(rev):
	if(stamina < DASH_STAMINA):
		return
	
		# check for dash
	if("right" in last_inputs and not "right" in cmds):
		last_r_depress = time_elapsed
	
	if("left" in last_inputs and not "left" in cmds):
		last_l_depress = time_elapsed
		
	if("right" in cmds and time_elapsed - last_r_depress < DASH_DETECTION_TIME):
		attack_executed = "dash"
		cooldown = DASH_COOLDOWN
		velocity.x += DASH_VELOCITY * rev
		stamina -= DASH_STAMINA
		
	if("left" in cmds and time_elapsed - last_l_depress < DASH_DETECTION_TIME):
		attack_executed = "dash"
		cooldown = DASH_COOLDOWN
		velocity.x -= (DASH_VELOCITY / 2) * rev
		stamina -= DASH_STAMINA

func setAnim(anim,rev):
	get_node("Pounce").visible = (anim == "Pounce")
	get_node("Bite").visible = (anim == "Bite")
	get_node("Idle").visible = (anim == "Idle")
	get_node("Walk").visible = (anim == "Walk")
	get_node("Reverse").visible = (anim == "Reverse")
	get_node("Projectile").visible = (anim == "Projectile")
	get_node("Damage").visible = (anim == "Damage")
	get_node("Sit").visible = (anim == "Sit")

func getActiveAnim():
	var anims = ["Pounce","Bite","Idle","Walk","Reverse","Projectile"]
	for i in anims:
		if(get_node(i).visible):
			return get_node(i)

func updateAnimator(rev):
	if(attack_executed == "special"):
		setAnim("Pounce",rev)
	elif(attack_executed == "ranged"):
		setAnim("Projectile",rev)
	elif(attack_executed == "close"):
		setAnim("Bite",rev)
	elif(velocity.x > VEL_ANIM_THRESH):
		setAnim("Walk",rev)
	elif(velocity.x < -VEL_ANIM_THRESH):
		setAnim("Reverse",rev)
	else:
		setAnim("Idle",rev)

func doInput(rev, delta):
	
	if(hurtTime > 0):
		if(hurtTime == 0.04):
			print("0")
			get_node("Damage").frame = 4
		hurtTime -= delta
		setAnim("Damage",rev)
		return
	
	cooldown -= delta

	if(cooldown < 0):
		attack_executed = ""
		attack_consumed = false
	
	# cancel move if holding fight keys, or in cooldown
	if("close" in cmds or "ranged" in cmds or "special" in cmds or cooldown > 0):
		cmds.erase("left")
		cmds.erase("right")
		
	
	# make sure animator's reset
	if(not "right" in cmds):
		if( get_node("Walk").frame == 0):
			get_node("Walk").frame = 0
	elif(get_node("Walk").frame == 8):
		get_node("Walk").frame = 2
		
	# make sure animator's reset
	if(not "left" in cmds):
		if( get_node("Reverse").frame == 0):
			get_node("Reverse").frame = 0
	elif(get_node("Reverse").frame == 8):
		get_node("Reverse").frame = 2
	
	updateAnimator(rev)
		
	if(get_node("../").trans_time > 0):
		if(Progress.progress == 0):
			setAnim("Sit", 1)
		return
	
	time_elapsed += delta

	checkForDash(rev)
	
	last_inputs = cmds

	tryAttacks(rev,delta)
	
	if(charge_command == "ranged" and charge_time > RANGED_CHARGE_TWO):
		get_node("Idle").modulate = Color(0.8,0.8,1)
	elif(charge_command == "ranged" and charge_time > RANGED_CHARGE_ONE):
		get_node("Idle").modulate = Color(1,0.8,0.8)
	else:
		get_node("Idle").modulate = Color(1,1,1)
	
	
	if("right" in cmds):
		velocity.x += delta * MOVESPEED * rev
	if("left" in cmds):
		velocity.x -= delta * (MOVESPEED * BACKUP_SPEED_RATIO) * rev
	if(not "left" in cmds and not "right" in cmds):
		stamina = min(stamina + delta * STAMINA_REGEN, 100)

func spawnHitMarker(pos):
	var d = damagefx.instance()
	get_parent().add_child(d)
	d.global_position = pos
	d.emitting = true

func heal():
	hp = min(4,hp + 1)
	get_node("Heal").play()

func pointHurt(rev,pos,kb):
	var space_state = get_world_2d().direct_space_state
	var layer = 2
	if(rev == -1):
		layer = 1
	
	# try hitting thrice
	for i in range(3):
		var result = space_state.intersect_ray(pos - Vector2(rev * 10,0), pos + Vector2(0,i*-15), [], layer, true, true)

		if(result):
			if("Mob" in result.collider.get_parent().name):
				result.collider.get_parent().hit()
			else:
				result.collider.hit(rev,kb)
			spawnHitMarker(pos+ Vector2(0,i*-15))
			get_node("BiteSound").play()
			return true
	return false

func tryCloseAttack(rev, delta):
	if(attack_executed == "close" and cooldown > CLOSE_ATTACK_HIT and cooldown < CLOSE_ATTACK_LAUNCH ):
		if(not attack_consumed):
			addMoveEffect(global_position)
			attack_consumed = pointHurt(rev, global_position + Vector2(rev * 70,-5), CLOSE_ATTACK_KNOCKBACK)
		
	if(attack_executed == "close" and cooldown > CLOSE_ATTACK_LAUNCH and cooldown - delta <= CLOSE_ATTACK_LAUNCH):
		velocity.x += CLOSE_ATTACK_VEL_BOOST * rev
			
	# put in an order to execute "close" attack
	if("close" in cmds and cooldown < 0):
		cooldown = CLOSE_ATTACK_COOLDOWN
		attack_executed = "close"
		get_node("Bite").frame = 0
		charge_command = ""
		return true
	return false

func tryRangedAttack(rev, delta):
	if(attack_executed == "ranged" and cooldown > RANGED_ATTACK_HIT and cooldown - delta <= RANGED_ATTACK_HIT):
		var v = null
		if(charge_time >= RANGED_CHARGE_TWO):
			v = ball.instance()
			v.velocity = Vector2(rev * BALL_SPEED_X,-BALL_SPEED_Y)
			v.team = rev
		else:
			v = frisbee.instance()
			v.linear_velocity = Vector2(rev * FRISBEE_SPEED_X,-FRISBEE_SPEED_Y)
		get_node("../Projectiles").add_child(v)
		v.global_position = global_position + Vector2(rev * 90,-50)
		charge_command = ""
		charge_time = 0
		
	if("ranged" in cmds and cooldown < 0):
		if(charge_command == ""):
			charge_command = "ranged"
		charge_time += delta
		return true
	else:
		if(charge_command == "ranged" and charge_time > RANGED_CHARGE_ONE and cooldown < 0):
			attack_executed = "ranged"
			cooldown = RANGED_COOLDOWN
			get_node("Projectile").frame = 0
			return true
	return false
	
func trySpecialAttack(rev,delta):
	if(attack_executed == "special" and cooldown > POUNCE_ATTACK_HIT and cooldown < POUNCE_ATTACK_LAUNCH):	
		if(not attack_consumed):
			addMoveEffect(global_position)
			attack_consumed = pointHurt(rev, global_position + Vector2(rev * 130,-15), POUNCE_ATTACK_KNOCKBACK)
			if(not attack_consumed):
				attack_consumed = pointHurt(rev, global_position + Vector2(rev * 130,40), POUNCE_ATTACK_KNOCKBACK)
	
	if(attack_executed == "special" and cooldown > POUNCE_ATTACK_LAUNCH and cooldown - delta <= POUNCE_ATTACK_LAUNCH):
		velocity.x += POUNCE_ATTACK_VEL_BOOSTX * rev
		velocity.y += POUNCE_ATTACK_VEL_BOOSTY
		# hit them during the pounce frame

	# put in an order to execute "close" attack
	if("special" in cmds and cooldown < 0):
		cooldown = POUNCE_ATTACK_COOLDOWN
		attack_executed = "special"
		get_node("Pounce").frame = 0
		
		charge_command = ""
		return true
	return false

func tryAttacks(rev, delta):
	# short circuit lmoa
	return tryCloseAttack(rev, delta) || tryRangedAttack(rev, delta) || trySpecialAttack(rev,delta)

func applyForces(delta):
	velocity.x = velocity.x * (1 - (delta * DAMPEN_FACTOR))
	velocity.y += GRAVITY * delta

