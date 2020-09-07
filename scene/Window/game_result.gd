extends Control

var player         = preload('res://models/playerManager.gd').new()
var stage          = load('res://models/stageManager.gd').new()

func _ready():
	pass # Replace with function body.

func create(jenis, score = 0, waktu = 0, uang = 0, memo=""):
	get_node(".").show()
	set_subject(jenis)
	var jilid = GlobalVar.get_jilid()
	var staged = GlobalVar.get_stage()
	$Control/TextureRect/memo.text = memo
	if(jenis == "menang"):
		$Control/Score.text = str(score)
		$Control/time.text = str(waktu)
		$Control/money.text = "+"+str(uang)
		player.give_money(uang)
		print(jilid)
		print(stage)
		print(score)
		if(int(stage.get_high_score(jilid, staged)) < score):
			stage.set_high_score(jilid, staged, score)
		stage.set_complete_stage(jilid, staged)
	else:
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
	get_tree().change_scene("res://scene/Menu/Synthesis.tscn")
	#get_tree().change_scene("res://scene/Menu/Chapter/Ch"+str(GlobalVar.get_jilid())+".tscn")
