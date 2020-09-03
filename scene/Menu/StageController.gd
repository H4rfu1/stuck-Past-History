extends Control

var unlocked_equip = 1

func _ready():
	_starter()
	$transition/AnimationPlayer.play("fade_out")
	for btn in get_tree().get_nodes_in_group(get_node(".").name):
		btn.connect("pressed", self, "on_select_stage", [btn.name])

func _starter():
	if( get_node(".").name != "StageSelector" ):
		_on_deselect_stage()
		render_equip()

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
	goto_scene("Chapter/Ch1")





func on_select_stage(button):
	var stage = button.split('_', false, 1)
	stage     = stage[1]

	#$StageInfo/Head/StageTitle.text
	$StageInfo/Head/StageNum.text = str(stage)
	#$StageInfo/Head/StageDesc.text

	$StageInfo.show()
	$Deselect.show()

func _on_deselect_stage():
	$Deselect.hide()
	$StageInfo.hide()
	$EquipBox.hide()

################
# Button Equip #
################
func render_equip():
	for btn in get_tree().get_nodes_in_group("equip"):
		btn.connect("pressed", self, "open_equip", [btn.name])

func open_equip(slot):
	$EquipBox.show()
	$Deselect.show()
	slot = slot.split('_', false, 1)
	slot = int(slot[1])
	if slot <= unlocked_equip:
		pass #equip window
	else:
		pass #unlock window

func _on_equip():
	_on_deselect_stage()

#################
# Button Action #
#################
func _on_btn_start():
	goto_scene("Chapter/Ch1/1")
func _on_btn_info():
	var durasi = float(60/60)
	$dialog_window.show()
	$dialog_window.create(["Durasi permainan: "+str(durasi)+" menit \nPetunjuk: \n1.Gunakan tombol kendali untuk menggerakkan karakter\n2.Hindari interaksi dengan penduduk lokal agar tidak mengubah jejak sejarah\n3. Temukan artefak/ peninggalan sejarah disetiap permainan\n 4. Saat menemukan artefak/ peninggalan sejarah, potret objek tersebut dengan berlari menenuhi seluruh kotak yang tersedia\n5. Pastikan agar tidak terlalu lama pada berdiri pada kotak pengambilan foto"])



