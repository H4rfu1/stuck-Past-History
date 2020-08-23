extends Node2D

onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animate")
#	# warning-ignore:return_value_discarded
#	connect("animation_finished", self, "_on_animation_finished")
#	play("Animate")

func _on_AnimatedSprite_animation_finished():
	queue_free()
