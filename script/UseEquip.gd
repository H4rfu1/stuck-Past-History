extends CanvasLayer

var item            = load("res://models/itemManager.gd").new()


func _ready():
	var node = get_parent().get_node('CanvasLayer/UI/HUD_Item/equip')
	for btn in node.get_children():
		btn.connect("pressed", self, "activate_item", [btn])

func activate_item(id_equip):
	id_equip = id_equip.name.split('_', false, 1)
	id_equip = int(id_equip[1]) #id_equip
	if GlobalVar.get_lim_equip()[id_equip] <= 0:
		return
	if(id_equip != 0):
		var id = GlobalVar.get_equip()[id_equip]
		var item_id = item.get_item_byid(id)[0] #id item
		if( item_id == 1 ):
			print("Ramuan Interator aktif")
			get_parent().get_node("Ysort/player").aktifkanTasRoket()
		elif( item_id == 2 ):
			print("Jubah Lenticular aktif")
			get_parent().get_node("Ysort/player").aktifkanJubahLenticular()
		elif( item_id == 3 ):
			print("Jam Penghenti Waktu aktif")
			get_parent().get_node("Ysort/player").aktifkanPenghentiWaktu()
		else:
			print("Jam Penghenti Waktu aktif")
			get_parent().get_node("Ysort/player").aktifkanBajuAdat(item_id)
#		match item_id:
#			1 :#or "Ramuan Interatom":
#				print("Ramuan Interator aktif")
#				get_parent().get_node("$Ysort/player").aktifkanTasRoket()
#			2 :#or "Jubah Lenticular":
#				print("Jubah Lenticular aktif")
#				get_parent().get_node("$Ysort/player").aktifkanJubahLenticular()
#			3 :#or "Jam Penghenti Waktu":
#				print("Jam Penghenti Waktu aktif")
#				get_parent().get_node("$Ysort/player").aktifkanPenghentiWaktu()
#			4 :#or "Baju Adat":
#				use_baju_adat(item_id)
#			5 :#or "Baju Adat":
#				use_baju_adat(item_id)
#			6 :#or "Baju Adat":
#				use_baju_adat(item_id)
		item.remove_item(id, 1)
	else:
		use_radar()
	GlobalVar.mod_lim_equip(id_equip,GlobalVar.get_lim_equip()[id_equip]-1)
	get_parent().render_equip()

func use_radar():
	print("radar aktif")
	get_parent().get_node("Ysort/player").aktifkanRadar()
	pass

func use_baju_adat(item_id):
	pass
