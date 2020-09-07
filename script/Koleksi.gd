extends Control

var item            = preload("res://models/itemManager.gd").new()
onready var intro   = get_node("/root/Intro")
const click_sound   = preload("res://scene/Music and Sounds/click.tscn")
var sound_state     = true

var page = 1
var max_page = 3

func _ready():
	if(!Intro.playing):
		intro.play()
	$transition/AnimationPlayer.connect("animation_finished",self, "trasition_finished")
	$transition.visible = true
	$transition/AnimationPlayer.play("wipe_out")


func _on_return_to_menu():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	goto_scene("Main")

func goto_scene(target: String, anim = "wipe")->void:
	$transition/AnimationPlayer.play(anim+"_in")
	var transition = yield($transition/AnimationPlayer, "animation_finished")
	if(transition == "wipe_in"):
		get_tree().change_scene("res://scene/Menu/"+target+".tscn")

func paginated(type,value):
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	match type:
		"next":
			if(page == max_page):
				return
			else:
				page +=1
		"back":
			if(page == 1):
				return
			else:
				page -=1
	render_page(page)

func _on_right_pressed():
	paginated("next",1)

func _on_left_pressed():
	paginated("back",1)

func render_page(pg):
	pass
