extends KinematicBody2D

#const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
signal collided
var timer = 0

const fail = preload("res://scene/Music and Sounds/fail.tscn")
const trap_hurt = preload("res://scene/Music and Sounds/sound_trap.tscn")
const mob_hurt = preload("res://scene/Music and Sounds/sound_mob.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

onready var direction = get_parent().get_parent().get_node("Direction")

enum {
	MOVE,
	ROLL,
	ATTACK
}

var stats = PlayerStats

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState  = animationTree.get("parameters/playback")
onready var joystick = get_parent().get_parent().get_node("CanvasLayer/Joystick/joystickbutton")
onready var hurtbox = $Hurtbox
#onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	stats.status = "ongoing"
#	randomize()
	stats.connect("no_health", self, "ulangi_lagi")
	animationTree.active = true
#	swordHitbox.knockback_vector = roll_vector


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
#
		ROLL:
			pass
#			roll_state()
#
		ATTACK:
			attack_state()
	
	if Input.is_action_pressed('tas_roket'):
		aktifkanTasRoket()
	
	if Input.is_action_pressed('jubah_lenticular'):
		aktifkanJubahLenticular()
	
	if Input.is_action_pressed('penghenti_waktu'):
		aktifkanPenghentiWaktu()
	
	if Input.is_action_pressed('baju_adat'):
		aktifkanBajuAdat()
	
	if Input.is_action_pressed('radar'):
		aktifkanRadar()
#
func move_state(delta):
	var input_vector = Vector2.ZERO
	var input_joystick = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	print(input_vector)
	input_vector = input_vector.normalized()
	input_joystick = joystick.get_value()
#
	if input_vector != Vector2.ZERO or input_joystick != Vector2.ZERO:
		roll_vector = input_vector
#		swordHitbox.knockback_vector = input_vector
		animationState.travel("Run")
		if(input_vector != Vector2.ZERO):
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationTree.set("parameters/Attack/blend_position", input_vector)
#			animationTree.set("parameters/Roll/blend_position", input_vector)
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			animationTree.set("parameters/Idle/blend_position", input_joystick)
			animationTree.set("parameters/Run/blend_position", input_joystick)
			animationTree.set("parameters/Attack/blend_position", input_joystick)
			velocity = velocity.move_toward(input_joystick * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		if(input_vector != Vector2.ZERO):
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#
	move()
#
#	if Input.is_action_just_pressed("roll"):
#		state = ROLL
#
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
#
#func roll_state():
#	velocity = roll_vector * ROLL_SPEED
#	animationState.travel("Roll")
#	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
#		if collision:
#			print("kolide")
#			emit_signal('collided', collision)
#func roll_animation_finished():
#	velocity = velocity * 0.8
#	state = MOVE

func attack_animation_finished():
	state = MOVE

#func _on_Hurtbox_area_entered(area):
#	#stats.health -= area.damage
#	hurtbox.start_invincibility(0.6)
#	hurtbox.create_hit_effect()
#	#var playerHurtSound = PlayerHurtSound.instance()
#	#get_tree().current_scene.add_child(playerHurtSound)

#func _on_Hurtbox_invincibility_started():
#	blinkAnimationPlayer.play("Start")

#func _on_Hurtbox_invincibility_ended():
#	blinkAnimationPlayer.play("Stop")




func _on_CrackHit_body_entered(body):
	print(body)
	print("oke")
	emit_signal('collided', body)

func aktifkanTasRoket():
	var timerT = Timer.new()
	timerT.set_wait_time( 10 )
	timerT.connect("timeout",self,"_on_timerT_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timerT) #to process
	timerT.start() #to start
	.set_collision_mask_bit( 0, false )
	.set_collision_layer_bit( 7, false )

func aktifkanJubahLenticular():
	var timerJ = Timer.new()
	timerJ.set_wait_time( 20 )
	timerJ.connect("timeout",self,"_on_timerJ_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timerJ) #to process
	timerJ.start() #to start
	.set_collision_layer_bit( 1, false )

func aktifkanPenghentiWaktu():
	var timerP = Timer.new()
	timerP.set_wait_time( 20 )
	timerP.connect("timeout",self,"_on_timerP_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timerP) #to process
	timerP.start() #to start
	.set_collision_layer_bit( 1, false )
	.set_collision_layer_bit( 7, false )

func aktifkanRadar():
	var timerR = Timer.new()
	timerR.set_wait_time( GlobalVar.get_radar() )
	timerR.connect("timeout",self,"_on_timerR_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timerR) #to process
	timerR.start() #to start
	direction.visible = true

func aktifkanBajuAdat():
	 .set_collision_layer_bit( 1, false )
func nonAktifkanBajuAdat():
	 .set_collision_layer_bit( 1, true )

func _on_timerT_timeout():
	.set_collision_mask_bit( 0, true )
	.set_collision_layer_bit( 7, true )

func _on_timerJ_timeout():
	.set_collision_layer_bit( 1, true )

func _on_timerR_timeout():
	direction.visible = false

func _on_timerP_timeout():
	.set_collision_layer_bit( 1, true )
	.set_collision_layer_bit( 7, true )

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	if(area.enemyTipe == "mob"):
		var mob = mob_hurt.instance()
		get_tree().current_scene.add_child(mob)
	else:
		var trap = trap_hurt.instance()
		get_tree().current_scene.add_child(trap)
	hurtbox.start_invincibility(0.6)

func ulangi_lagi():
	var Fail = fail.instance()
	get_tree().current_scene.add_child(Fail)
	var result = get_parent().get_parent().get_node("CanvasLayer/game_result2")
	result.create("coba_lagi", 0, "", 0)
	stats.status = "mengulang"
	$".".set_physics_process(false)
	$".".hurtbox.set_collision_layer_bit( 2, false)
	var mob = get_parent().get_node("Mob")
	for node in mob.get_children():
		node.set_physics_process(false)
	
	
	
