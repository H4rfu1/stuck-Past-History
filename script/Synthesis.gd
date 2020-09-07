extends Control

var item           = preload("res://models/itemManager.gd").new()

var id

func _ready():
	_play(item.convert_jilid_stage_to_id(GlobalVar.get_jilid(), GlobalVar.get_stage()))
	pass

func _play(ids):
	id = ids
	var koleksi = item.get_koleksi_byid(id)
	$Control/obj.texture = load(koleksi[4])
	$ColorRect.show()
	$AnimationPlayer.play("generate")

func _Ok_pressed():
	get_tree().change_scene("res://scene/Menu/Chapter/Ch"+str(GlobalVar.get_jilid())+".tscn")


func _on_info():
	var koleksi = item.get_koleksi_byid(id)
	$dialog_window.create([koleksi[2]+"\n"+koleksi[3]])
