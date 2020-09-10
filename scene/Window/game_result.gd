extends Control

var player         = preload('res://models/playerManager.gd').new()
var stage          = load('res://models/stageManager.gd').new()
var item           = load('res://models/itemManager.gd').new()
const click_sound  = preload("res://scene/Music and Sounds/click.tscn")

var first_complete = false
var menang = false setget set_menang, get_menang
var reward

func _ready():
	pass # Replace with function body.

func create(jenis, score = 0, waktu = 0, uang = 0, memo=""):
	get_node(".").show()
	set_subject(jenis)
	var jilid = GlobalVar.get_jilid()
	var staged = GlobalVar.get_stage()
	if(jenis == "menang"):
		set_menang(true)
		first_complete = stage.first_complete_stage(jilid, staged)
		give_reward(jilid, staged)
		if(reward[0] != 0):
			$Control/TextureRect/memo.text = str(item.get_item_byid(reward[0])[1])+' x'+str(reward[1])
		else:
			$Control/TextureRect/memo.text = ''
		#if typeof(drop) == 21:
		#	print(str(item.get_item_byid(drop[0])[1])+' x'+str(drop[1]))
		#	$Control/TextureRect/memo.text = str(item.get_item_byid(drop[0])[1])+' x'+str(drop[1])
		#else:
		#	$Control/TextureRect/memo.text = memo
		$Control/Score.text = str(score)
		$Control/time.text = "Sisa Waktu "+str(waktu)
		$Control/money.text = "+"+str(uang)
		player.give_money(uang)
		if(int(stage.get_high_score(jilid, staged)) < score):
			stage.set_high_score(jilid, staged, score)
		stage.set_complete_stage(jilid, staged)
	else:
		set_menang(false)
		$Control/Score.text = str(score)
		$Control/time.hide()
		$Control/money.hide()
	pass

func set_subject(type):
	match type:
		"menang":
			$Control/TextureRect/subject.texture  = load("res://assets/UI/window/message/result_berhasil.png")
		"coba_lagi":
			$Control/TextureRect/subject.texture  = load("res://assets/UI/window/message/result_coba lagi.png")
		"waktu_habis":
			$Control/TextureRect/subject.texture  = load("res://assets/UI/window/message/result_waktu habis.png")


func _btn_oke():
	var clickSound = click_sound.instance()
	var jilid = GlobalVar.get_jilid()
	var staged = GlobalVar.get_stage()
	get_tree().current_scene.add_child(clickSound)
	if (get_menang() and GlobalVar.get_mode() == "tutor_main2"):
		get_tree().change_scene("res://scene/Menu/Main.tscn")
	elif ((get_menang() == false) and GlobalVar.get_mode() == "tutor_main2"):
		get_tree().change_scene("res://scene/Menu/Chapter/Ch0/0-1.tscn")
	elif (get_menang() and GlobalVar.get_mode() == "selesai_tutor"):
		get_tree().change_scene("res://scene/Menu/StageSelector.tscn")
	elif ((get_menang() == false) and GlobalVar.get_mode() == "0-2"):
		get_tree().change_scene("res://scene/Menu/Chapter/Ch0/0-2.tscn")
	elif(get_menang()):
		get_tree().change_scene("res://scene/Menu/Synthesis.tscn")
	else:
		get_tree().change_scene("res://scene/Menu/Chapter/Ch"+str(GlobalVar.get_jilid())+".tscn")

func set_menang(args):
	menang = args
func get_menang():
	return menang

func give_reward(jilid, staged):
	var rng = RandomNumberGenerator.new()
	item.add_koleksi(jilid, staged)
	var rate = rng.randi_range(1,100)
	var id = 0
	var amount = 0
	match jilid:
		0:
			amount = 1
			match staged:
				'0-1':
					if(first_complete):
						id = 1
				'0-2':
					if(first_complete):
						id = 1
		1:
			amount  = 1
			match staged:
				'1':
					if(first_complete):
						id = 4
				'2':
					if(first_complete):
						id = 5
				'3':
					if(first_complete):
						id = 6
				'3-1':
					if(rate > 90):
						id = 2
						amount = 1
				'3-2':
					if(rate > 80):
						id = 2
						amount = 1
				'4':
					if(first_complete):
						id = 8
					else:
						id = 0
		2:
			pass
	if (id != 0) :
		item.add_item(id, amount)
	reward = [id, amount]
