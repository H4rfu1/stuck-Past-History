extends KinematicBody2D

#const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 75
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4
var direction = Vector2.ZERO
var ngejar = true

const pentung = preload("res://scene/Effects/pentung.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

onready var playerDetectionZone = $PlayerDetection
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
#onready var animationPlayer = $AnimationPlayer
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState  = animationTree.get("parameters/playback")

func _ready():
	state = pick_random_state([IDLE, WANDER])
	animationTree.active = true

func _physics_process(delta):
#	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
#	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animationState.travel("Idle")
			animationTree.set("parameters/Idle/blend_position", direction)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				if ngejar == true:
					get_node("pentung/anim").play("play")
					ngejar = false
					$range.visible = true
				accelerate_towards_point(player.global_position, delta)
			else:
				ngejar = true
				$range.visible = false
				state = IDLE

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	direction = global_position.direction_to(point)
	direction = direction.normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	if direction != Vector2.ZERO:
		animationState.travel("Run")
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Run/blend_position", direction)
	else:
		animationState.travel("Idle")
		animationTree.set("parameters/Idle/blend_position", direction)
		

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

#func _on_Hurtbox_area_entered(area):
#	stats.health -= area.damage
#	knockback = area.knockback_vector * 150
#	hurtbox.create_hit_effect()
#	hurtbox.start_invincibility(0.4)


func _on_Hurtbox_area_entered(area):
	pass
#	queue_free()
