extends Control
onready var Page = load("res://scene/Menu/MenuController.gd").new()


func _ready():
	$tape.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimationPlayer.play("tape_open")

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "tape_open"):
		$tape.hide()
		$AnimationPlayer.play("game_logo")
	else:
		get_tree().change_scene("res://scene/Menu/Main.tscn")
