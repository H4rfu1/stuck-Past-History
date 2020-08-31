extends Control

onready var DB      = load("res://script/plugins/DBconnection.gd").new()
onready var Helper  = preload("res://script/plugins/DBhelper.gd").new()

var sound_state     = true
var toko_active_btn = "timemachine" 

func _ready():
	_load_conf()
	_starter()
	pass

func _load_conf():
	pass

func _starter():
	$transition/AnimationPlayer.connect("animation_finished",self, "trasition_finished")
	$transition.visible = true
	$transition/AnimationPlayer.play("wipe_out")
	if( get_node(".").name == "Toko"):
		GlobalVar.toko
		render_toko_btn(GlobalVar.get_toko())

#######################
# Button Press Action #
#######################
func _on_press_Main():
	goto_scene("StageSelector")
func _on_press_MesinWaktu():
	GlobalVar.set_toko("timemachine")
	goto_scene("Toko")
func _on_press_Toko():
	GlobalVar.set_toko("powerup")
	goto_scene("Toko")
func _on_press_Koleksi():
	goto_scene("Koleksi")
func _on_press_Cerita():
	goto_scene("Cerita")
func _on_press_Leaderboard():
	$leaderboard_window.visible = true
func _on_press_Setting():
	$setting_window.visible = true
func _on_return_to_menu():
	goto_scene("Main")

func goto_scene(target: String, anim = "wipe")->void:
	$transition/AnimationPlayer.play(anim+"_in")
	var transition = yield($transition/AnimationPlayer, "animation_finished")
	if(transition == "wipe_in"):
		get_tree().change_scene("res://scene/Menu/"+target+".tscn")

#######################
#  Specific Function  #
#######################
func render_toko_btn(button):
	#load("res://res://assets/UI/window/btn_nav_inactive.png")
	for child in $Background/btn_group.get_children():
		var ipos = get_node("Background/btn_group/"+str(child.name)+"/Icon").rect_position
		get_node("Background/btn_group/"+str(child.name)+"/Icon").rect_position.y = -10
		if( child.name != "btn_"+button ):
			child.disabled = false
			child.texture_normal = load("res://assets/UI/window/btn_nav_inactive.png")
			child.texture_hover  = load("res://assets/UI/window/btn_nav_active.png")
			get_node("Background/btn_group/"+str(child.name)+"/Label").hide()
			get_node("Background/btn_group/"+str(child.name)+"/Icon").rect_position.y = 15
		else:
			child.disabled = true
			child.texture_normal = load("res://assets/UI/window/btn_nav_active.png")
			get_node("Background/btn_group/"+str(child.name)+"/Label").show()
	for child in $Background/card/ScrollContainer.get_children():
		if( child.name != "slot_"+button):
			child.hide()
		else:
			child.show()

func _on_toko_powerup():
	render_toko_btn("powerup")
func _on_toko_timemachine():
	render_toko_btn("timemachine")
func _on_toko_inventory():
	render_toko_btn("inventory")
	#fetch json data from owned item as object


