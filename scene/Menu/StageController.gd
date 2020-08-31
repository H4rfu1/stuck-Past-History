extends Control

func _ready():
	$transition/AnimationPlayer.play("fade_out")


func goto_scene(target: String, anim = "fade")->void:
	$transition/AnimationPlayer.play(anim+"_in")
	var transition = yield($transition/AnimationPlayer, "animation_finished")
	if(transition == "fade_in"):
		get_tree().change_scene("res://scene/Menu/"+target+".tscn")

func _on_return_to_menu():
	goto_scene("Main")
func _on_ch1():
	goto_scene("Ch/ch1")



