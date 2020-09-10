extends Control

var item           = load("res://models/itemManager.gd").new()
var player         = load('res://models/playerManager.gd').new()
var stage          = load('res://models/stageManager.gd').new()

const shop_item     = preload("res://scene/UI/shop_item.res")

const click_sound = preload("res://scene/Music and Sounds/click.tscn")
const click_start = preload("res://scene/Music and Sounds/Start.tscn")

export var scene = ""

onready var intro = get_node("/root/Intro")
onready var audio_game = get_node("/root/GamePlay")

var unlocked_equip = 1 setget set_unlockeq, get_unlockeq #slot item
var state_equip_box = false setget set_stateeq, get_stateeq #true for unlocked
var equip_id = 0
var equip_slot = 0

func _ready():
	if GlobalVar.get_mode() == "tutor_main" or (GlobalVar.get_mode() == "tutor_main2_play"  and scene == "stageSelector"):
		if(get_node(".").name == "Ch0"):
			get_node("tap2d/tap2").play("play")
	elif GlobalVar.get_mode() == "tutor_main2_play":
		if(get_node(".").name == "Ch0"):
			get_node("tap2d3/tap2").play("play")
#		get_node("tap2d2/tap2").play("play")
	if (!intro.playing and audio_game.playing):
		audio_game.stop()
		intro.play()
	_starter()
	$transition/AnimationPlayer.play("fade_out")
	for btn in get_tree().get_nodes_in_group(get_node(".").name):
		btn.connect("pressed", self, "on_select_stage", [btn.name])

func _starter():
	set_unlockeq(player.get_slot())
	if( get_node(".").name != "StageSelector" ):
		_on_deselect_stage()
		render_equip()
		render_powerup()
		equip_id = 0
		equip_slot = 0
		print(GlobalVar.equip)

func goto_scene(target: String, anim = "fade")->void:
	$transition/AnimationPlayer.play(anim+"_in")
	var transition = yield($transition/AnimationPlayer, "animation_finished")
	if(transition == "fade_in"):
		get_tree().change_scene("res://scene/Menu/"+target+".tscn")

func _on_return_to_menu():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	if( get_node(".").name == "StageSelector" ):
		goto_scene("Main")
	else:
		goto_scene("StageSelector")

###Select Jilid###
func _on_ch0():
	if GlobalVar.get_mode() == "tutor_main" or (GlobalVar.get_mode() == "tutor_main2_play"  and scene == "stageSelector"):
		get_node("tap2d/tap2").play("stop")
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	goto_scene("Chapter/Ch0")
	GlobalVar.set_jilid(0)

func _on_ch1():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	goto_scene("Chapter/Ch1")
	GlobalVar.set_jilid(1)


func on_select_stage(button):
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	var staged = button.split('_', false, 1)
	staged     = staged[1]
	if GlobalVar.get_mode() == "tutor_main" or (GlobalVar.get_mode() == "tutor_main2_play"):
		if staged == "0-1":
			get_node("tap2d/tap2").play("stop")
			get_node("tap2d7/tap2").play("play")
		else:
			get_node("tap2d2/tap2").play("stop")
			get_node("tap2d7/tap2").play("play")
	GlobalVar.set_stage(staged)
	staged     = stage.get_stage_bynumber(GlobalVar.get_jilid(), staged)
	print('staged',staged)
	$StageInfo/Head/StageTitle.text = staged[3]
	$StageInfo/Head/StageNum.text = str(staged[2])
	$StageInfo/Head/StageDesc.text = staged[4]
	$StageInfo/Contain/Poin.text = "Poin: "+str(staged[5])
	$StageInfo.show()
	$Deselect.show()

var escape_awal = false
func _on_deselect_stage():
#	if GlobalVar.get_mode() == "tutor_main":
#		get_node("tap2d/tap2").play("play")
#		get_node("tap2d2/tap2").play("stop")
#		get_node("tap2d4/tap2").play("stop")
#		get_node("tap2d5/tap2").play("stop")
#		get_node("tap2d6/tap2").play("stop")
#		get_node("tap2d7/tap2").play("stop")
#		get_node("tap2d8/tap2").play("stop")
#	elif GlobalVar.get_mode() == "tutor_main2_play":
#		get_node("tap2d3/tap2").play("play")
#		get_node("tap2d2/tap2").play("stop")
#		get_node("tap2d4/tap2").play("stop")
#		get_node("tap2d5/tap2").play("stop")
#		get_node("tap2d6/tap2").play("stop")
#		get_node("tap2d7/tap2").play("stop")
#		get_node("tap2d8/tap2").play("stop")
	if escape_awal:
		var clickSound = click_sound.instance()
		get_tree().current_scene.add_child(clickSound)
	$Deselect.hide()
	$StageInfo.hide()
	$EquipBox.hide()
	escape_awal = true

################
# Button Equip #
################
func render_equip():
	var equip = GlobalVar.get_equip()
	var i = 1
	for btn in get_tree().get_nodes_in_group("equip"):
		var icon =btn.get_child(0)
		if( equip[i] != 0 ):
			var eq = item.get_item_byid(equip[i])
			icon.texture = load(eq[4])
			btn.texture_normal = load("res://assets/UI/window/item_frame.png")
		else:
			if(get_unlockeq() >= i):
				btn.texture_normal = load("res://assets/UI/window/item_null.png")
				btn.get_child(0).set_texture(null)
			else:
				icon.texture = load("res://assets/UI/utility/locked.png")
		i +=1
		btn.connect("pressed", self, "open_equip", [btn.name])

func render_powerup():
	for child in $EquipBox/Card/equip/opsi_item.get_children():
		child.free()
	for power in item.get_all_item():
		var obj = shop_item.instance()
		obj.name = "power_"+str(power[1])
		print(obj.name)
		if power[5] == 1:
			obj.hide()
		$EquipBox/Card/equip/opsi_item.add_child(obj)
		var new_obj = "EquipBox/Card/equip/opsi_item/power_"+str(power[1])
		if( power[0] in GlobalVar.get_equip()): #kalau gaada itemnya
			get_node(new_obj).hide()
		var own = item.owned_item_id(power[0])
		if own > 0:
			get_node(new_obj+"/own").text = "Punya: "+ str(own)
		else: 
			get_node(new_obj).hide()
		get_node(new_obj+"/cost").hide()
		get_node(new_obj+"/icon").texture = load(power[4])
		get_node(new_obj).connect("pressed", self, "select_powerup", [obj])

func select_powerup(itm):
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	if GlobalVar.get_mode() == "tutor_main2_play":
		get_node("tap2d4/tap2").play("stop")
		get_node("tap2d5/tap2").play("play")
	var obj = itm.name.split('_', false, 1)
	obj = obj[1]
	$EquipBox/Card/itemname.text = item.get_item_byname(obj)[1]
	$EquipBox/Card/desc.bbcode_text = item.get_item_byname(obj)[2]
	equip_id = item.get_item_byname(obj)[0]
	

func open_equip(slot):
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	if GlobalVar.get_mode() == "tutor_main2_play":
		get_node("tap2d3/tap2").play("stop")
		get_node("tap2d4/tap2").play("play")
	$EquipBox.show()
	$Deselect.show()
	$EquipBox/Card/unlock/not_enough.hide()
	slot = slot.split('_', false, 1)
	slot = int(slot[1])
	equip_slot = slot
	if slot <= get_unlockeq():
		set_stateeq(true)
		print("oke siap equip")
		$EquipBox/Card/itemname.show()
		$EquipBox/Card/itemname.text = ""
		$EquipBox/Card/desc.show()
		$EquipBox/Card/desc.bbcode_text = ""
		$EquipBox/Card/equip.show()
		$EquipBox/Card/unlock.hide()
		pass #equip window
	else:
		set_stateeq(false)
		print("unlock dulu gan")
		$EquipBox/Card/itemname.hide()
		$EquipBox/Card/desc.hide()
		$EquipBox/Card/equip.hide()
		$EquipBox/Card/unlock.show()
		pass #unlock window

#################
# Button Action #
#################

func _on_btn_start(): #Masuk ke Permainan#
	if GlobalVar.get_mode() == "tutor_main":
		get_node("tap2d6/tap2").play("stop")
		GlobalVar.set_mode("0-1")
	elif GlobalVar.get_mode() == "tutor_main2_play":
		get_node("tap2d6/tap2").play("stop")
		GlobalVar.set_mode("0-2")
		
	intro.stop()
	var clickStart = click_start.instance()
	get_tree().current_scene.add_child(clickStart)
	goto_scene("Chapter/Ch"+str(GlobalVar.get_jilid())+"/"+str(GlobalVar.get_stage()))
	###goto_scene("Chapter/Ch1/1")
	
func _on_btn_info():
	if GlobalVar.get_mode() == "tutor_main"  or (GlobalVar.get_mode() == "tutor_main2_play"):
		get_node("tap2d7/tap2").play("stop")
		get_node("tap2d8/tap2").play("play")
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	var durasi = float(60/60)
	$dialog_window.show()
	$dialog_window.create(["Durasi permainan: "+str(durasi)+" menit \nPetunjuk: \n1.Gunakan tombol kendali untuk menggerakkan karakter\n2.Hindari interaksi dengan penduduk lokal agar tidak mengubah jejak sejarah\n3. Temukan artefak/ peninggalan sejarah disetiap permainan\n 4. Saat menemukan artefak/ peninggalan sejarah, potret objek tersebut dengan berlari menenuhi seluruh kotak yang tersedia\n5. Pastikan agar tidak terlalu lama pada berdiri pada kotak pengambilan foto"])

func _on_confirm_equip():
#	var clickSound = click_sound.instance()
#	get_tree().current_scene.add_child(clickSound)
	if GlobalVar.get_mode() == "tutor_main2_play":
		get_node("tap2d2/tap2").play("play")
		get_node("tap2d5/tap2").play("stop")
	if(get_stateeq()):
		pass
		var temp = GlobalVar.get_equip()
		temp[equip_slot] = equip_id
		GlobalVar.set_equip(temp)
		_on_deselect_stage()
		_starter()
	else:
		if(player.pay(5000)):
			player.add_slot()
			_on_deselect_stage()
			_starter()
		else:
			$EquipBox/Card/unlock/not_enough.show()


func set_unlockeq(args):
	unlocked_equip = args
func get_unlockeq():
	return unlocked_equip
func set_stateeq(args):
	state_equip_box = args
func get_stateeq():
	return state_equip_box
