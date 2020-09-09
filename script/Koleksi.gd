extends Control

var item            = preload("res://models/itemManager.gd").new()
const koleksi_item     = preload("res://scene/UI/koleksi_item.res")
onready var intro   = get_node("/root/Intro")
const click_sound   = preload("res://scene/Music and Sounds/click.tscn")
var sound_state     = true

var splited_record  = [] setget set_split_record, get_split_record

var page = 1
var max_page = 3

func _ready():
	if(!Intro.playing):
		intro.play()
	$transition/AnimationPlayer.connect("animation_finished",self, "trasition_finished")
	$transition.visible = true
	$transition/AnimationPlayer.play("wipe_out")
	#var data = [1,2,3,4,5,6,7,8,9,10,11,12, 3]
	#var current = 0
	#var start = float(data.size())/6
	#start = ceil(start)
	#for i in range(start):
	#	for j in range( (i*6), (i*6+6) ):
	#		if current < data.size():
	#			print (data[j])
	#		current +=1
	#	print("newline ke-",i)
	page_content()
	max_page = get_split_record().size()
	render_page(1)

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
	print(page)

func _on_right_pressed():
	print('next')
	paginated("next",1)

func _on_left_pressed():
	print('back')
	paginated("back",1)

func page_content():
	var data = item.get_all_koleksi()
	var current = 0
	var start = float(data.size())/6
	start = ceil(start)
	for i in range(start):
		var temp = []
		for j in range( (i*6), (i*6+6) ):
			if current < data.size():
				temp.append(data[j])
			current +=1
		set_split_record(temp)

func render_page(pg):
	page_content()
	for child in $Control/pg_1/VBoxContainer.get_children():
		child.free()
	var i = 0
	for koleksi in get_split_record()[pg]:
		var obj = koleksi_item.instance()
		obj.name = "koleksi_"+str(koleksi[2])
		$Control/pg_1/VBoxContainer.add_child(obj)
		var new_obj = "Control/pg_1/VBoxContainer/koleksi_"+str(koleksi[2])
		var own = koleksi[5]
		if own >= 1:
			get_node(new_obj+"/icon").set_modulate(Color(1,1,1,1))
		else: 
			get_node(new_obj+"/icon").set_modulate(Color(0,0,0,1))
		get_node(new_obj+"/name").text = str(koleksi[2])
		space_as_new_line(koleksi[2])
		i += 1

func space_as_new_line(string):
	string = string.split(' ', false)
	var tmp = ''
	for s in string:
		tmp = s+'\n'
	print(tmp)
func set_split_record(args):
	splited_record.append(args)

func get_split_record():
	return splited_record
