extends Control

var item           = preload("res://models/itemManager.gd").new()
const click_sound = preload("res://scene/Music and Sounds/click.tscn")
var sound_state     = true

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
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	get_tree().change_scene("res://scene/Menu/Chapter/Ch"+str(GlobalVar.get_jilid())+".tscn")


func _on_info():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	var koleksi = item.get_koleksi_byid(id)
	$dialog_window.create([koleksi[2]+"\n"+koleksi[3]])
