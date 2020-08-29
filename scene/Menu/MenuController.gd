extends Control

onready var DB     = load("res://script/plugins/DBconnection.gd").new()
onready var Helper = preload("res://script/plugins/DBhelper.gd").new()

var sound_state    = true

func _ready():
	_load_conf()
	_starter()
	pass

func _load_conf():
	pass

func _starter():
	$transition/AnimationPlayer.connect("animation_finished",self, "trasition_finished")
	$transition.visible = true
	$transition/AnimationPlayer.play("wipe_out");


#######################
# Button Press Action #
#######################
func _on_press_Main():
	goto_scene("StageSelector")
func _on_press_MesinWaktu():
	goto_scene("MesinWaktu")
func _on_press_Toko():
	goto_scene("Toko")
func _on_press_Koleksi():
	goto_scene("Koleksi")
func _on_press_Cerita():
	goto_scene("Cerita")
func _on_press_Leaderboard():
	pass
func _on_press_Setting():
	$setting_window.visible = true


func goto_scene(target: String, anim = "wipe")->void:
	$transition/AnimationPlayer.play(anim+"_in")
	var transition = yield($transition/AnimationPlayer, "animation_finished")
	if(transition == "wipe_in"):
		get_tree().change_scene("res://scene/Menu/"+target+".tscn")
