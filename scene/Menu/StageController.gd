extends Control

func _ready():
	$transition/AnimationPlayer.play("fade_out")


func goto_scene(target: String, anim = "fade")->void:
	$transition/AnimationPlayer.play(anim+"_in")
	var transition = yield($transition/AnimationPlayer, "animation_finished")
	if(transition == "fade_in"):
		get_tree().change_scene("res://scene/Menu/"+target+".tscn")

func _on_return_to_menu():
	if( get_node(".").name == "StageSelector" ):
		goto_scene("Main")
	else:
		goto_scene("StageSelector")
func _on_ch1():
	goto_scene("Chapter/ch1")



