extends KinematicBody2D

#const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
signal collided

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
#var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState  = animationTree.get("parameters/playback")
onready var joystick = get_parent().get_parent().get_node("CanvasLayer/Joystick/joystickbutton")
#onready var swordHitbox = $HitboxPivot/SwordHitbox
#onready var hurtbox = $Hurtbox
#onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	pass
#	randomize()
#	#stats.connect("no_health", self, "queue_free")
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
		if collision:
			print("kolide")
			emit_signal('collided', collision)
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
