extends Control

onready var DB      = load("res://script/plugins/DBconnection.gd").new()
onready var Helper  = preload("res://script/plugins/DBhelper.gd").new()
var local           = load("res://script/plugins/DBlocal.gd").new()
var item            = load("res://models/itemManager.gd").new()

const shop_item     = preload("res://scene/UI/shop_item.res")

var sound_state     = true
var toko_active_btn = "timemachine"

const click_sound = preload("res://scene/Music and Sounds/click.tscn")

var player setget set_player, get_player
var u_price setget set_u_price, get_u_price
var u_tier setget set_u_tier, get_u_tier

	#[type, id/ name, cost, amount]
var shop_cart setget set_shop_cart, get_shop_cart

onready var intro = get_node("/root/Intro")
onready var audio_game = get_node("/root/GamePlay")

var escape_awal = false

func _ready():
	if (!intro.playing and audio_game.playing):
		audio_game.stop()
		intro.play()
	if GlobalVar.get_mode() == "tutor_main" or GlobalVar.get_mode() == "tutor_main2_play":
		get_node("tutorial/tap2d/tap2").play("play")
	elif GlobalVar.get_mode() == "tutor_main2":
		get_node("tutorial/tap2d2/tap2").play("play")
	elif GlobalVar.get_mode() == "toko":
		get_node("tutorial/tap2d/tap2").play("play")
	if(!Intro.playing):
		intro.play()
	_load_conf()
	_starter()
	pass

func _load_conf():
	pass

func data_initial():
	set_player  (DB.readJSON("pemain"))
	set_u_price (DB.readJSON("u_price"))
	set_u_tier  (DB.readJSON("u_tier"))

func _starter():
	$transition/AnimationPlayer.connect("animation_finished",self, "trasition_finished")
	$transition.visible = true
	$transition/AnimationPlayer.play("wipe_out")
	if( get_node(".").name == "Toko"):
		GlobalVar.toko
		$CraftingMenu.hide()
		_on_cancel_purchase()
		render_toko_btn(GlobalVar.get_toko())
		data_initial()
		reload_money()
	elif ( get_node(".").name == "Main" ):
		$Background/AnimationPlayer.play("main_page")

#######################
# Button Press Action #
#######################
func _on_press_Main():
	get_node("tutorial/tap2d/tap2").play("stop")
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	goto_scene("StageSelector")
func _on_press_MesinWaktu():
	GlobalVar.set_toko("timemachine")
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	goto_scene("Toko")
func _on_press_Toko():
	GlobalVar.set_toko("powerup")
	if GlobalVar.get_mode() == "tutor_main2":
		get_node("tutorial/tap2d2/tap2").play("stop")
		GlobalVar.set_mode("toko")
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	goto_scene("Toko")
func _on_press_Koleksi():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	goto_scene("Koleksi")
func _on_press_Cerita():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	goto_scene("Cerita")
func _on_press_Leaderboard():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	$leaderboard_window.visible = true
func _on_press_Setting():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	$setting_window.visible = true
func _on_return_to_menu():
	if GlobalVar.get_mode() == "toko":
		get_node("tutorial/tap2d3/tap2").play("stop")
		GlobalVar.set_mode("tutor_main2_play")
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	goto_scene("Main")

func goto_scene(target: String, anim = "wipe")->void:
	$transition/AnimationPlayer.play(anim+"_in")
	var transition = yield($transition/AnimationPlayer, "animation_finished")
	if(transition == "wipe_in"):
		get_tree().change_scene("res://scene/Menu/"+target+".tscn")
func animation_finished():
	pass
func trasition_finished():
	pass
#######################
#  Specific Function  #
#######################
func render_toko_btn(button):
	#load("res://res://assets/UI/window/btn_nav_inactive.png")
	$Background/card/btn_rakit.hide()
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
			render_toko_item(button)
			child.show()

func _on_toko_powerup():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	render_toko_btn("powerup")
func _on_toko_timemachine():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	render_toko_btn("timemachine")
func _on_toko_inventory():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	render_toko_btn("inventory")
	#fetch json data from owned item as object

func _on_cancel_purchase():
	if escape_awal:
		var clickSound = click_sound.instance()
		get_tree().current_scene.add_child(clickSound)
	$PurchaseBox.hide()
	$Deselect.hide()
	escape_awal = true

func _on_confirm_buy_pressed():
	if GlobalVar.get_mode() == "toko":
		get_node("tutorial/tap2d3/tap2").play("play")
		get_node("tutorial/tap2d2/tap2").play("stop")
	var cart = get_shop_cart() #[type, id/ name, cost, amount]
	var cost = cart[2] * cart[3]
	var pmoney = get_player()["c"]
	if( pmoney < cost):
		pass
	else:
		pmoney -= cost
		pmoney = int(pmoney)
		DB.pushJSON(["c"], [pmoney], "pemain")
		if( cart[0] == "timemachine"):
			item.upgrade_timemachine(cart[1])
		elif( cart[0] == "powerup"):
			item.add_item(cart[1], cart[3])
			
	reload_money()
	render_toko_item(cart[0])
	_on_cancel_purchase()
	

func reload_money(reduceval = 0):
	data_initial()
	var money = get_player()['c']
	$Panel/money.text = str(money)
	#$Panel/money.text = str(money-reduceval)

func render_toko_item(type):
	data_initial()
	var price
	var template = "Background/card/ScrollContainer/slot_"+type+"/"
	match type:
		"timemachine":
			var sample = get_node(template+"upgrade_0")
			for btn in get_tree().get_nodes_in_group("timemachine"):
				btn.connect("pressed", self, "on_tap_toko_item", [btn])
				var item = btn.name.split('_', false, 1)
				item  = item[1]
				var maxtier = (get_u_price()[item][0]).size()
				var tier  = get_u_tier()[item]
				if( tier < maxtier ):
					price = str(get_u_price()[item][0][tier])
				else:
					price = "Maxed"
					#btn.disabled = true
				get_node("Background/card/ScrollContainer/slot_timemachine/upgrade_"+item+"/tier").text = "Tingkat: "+str(tier)
				get_node("Background/card/ScrollContainer/slot_timemachine/upgrade_"+item+"/cost").text = str(price)
			pass
		"powerup":
			var sample = get_node(template+"power_0")
			for child in $Background/card/ScrollContainer/slot_powerup.get_children():
				child.free()
			for power in item.get_all_item():
				var obj = shop_item.instance()
				obj.name = "power_"+str(power[1])
				if (power[5] == 1 or power[3] >=50000):
					obj.hide()
				$Background/card/ScrollContainer/slot_powerup.add_child(obj)
				var new_obj = "Background/card/ScrollContainer/slot_powerup/power_"+str(power[1])
				var own = item.owned_item_id(power[0])
				if own > 0:
					get_node(new_obj+"/own").text = "Punya: "+ str(own)
				else: 
					get_node(new_obj+"/own").hide()
				get_node(new_obj+"/cost").text = str(power[3])
				get_node(new_obj+"/icon").texture = load(power[4])
				get_node(new_obj).connect("pressed", self, "on_tap_toko_item", [obj])
			pass
		"inventory":
			$Background/card/btn_rakit.show()
			var sample = get_node(template+"item_0")
			for child in $Background/card/ScrollContainer/slot_inventory.get_children():
				child.free()
			for itm in item.get_all_inventory_items():
				var obj = shop_item.instance()
				var data_item = item.get_item_byid(itm[0])
				obj.name = "item_"+str(data_item[1])
				print(obj)
				$Background/card/ScrollContainer/slot_inventory.add_child(obj)
				var new_obj = "Background/card/ScrollContainer/slot_inventory/item_"+str(data_item[1])
				var own = item.owned_item_id(itm[0])
				if own > 0:
					get_node(new_obj+"/own").text = "Punya: "+ str(own)
				else: 
					get_node(new_obj).hide()
				get_node(new_obj+"/cost").hide()
				get_node(new_obj+"/icon").texture = load(data_item[4])
				get_node(new_obj).connect("pressed", self, "on_tap_toko_item", [obj])
			pass
	pass

func on_tap_toko_item(itm):
	if GlobalVar.get_mode() == "toko":
		get_node("tutorial/tap2d/tap2").play("stop")
		get_node("tutorial/tap2d2/tap2").play("play")
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	$PurchaseBox/Card/upgrade_arrow.hide()
	$PurchaseBox/Card/amount_input.hide()
	$PurchaseBox/Card/desc.bbcode_text = ""
	$PurchaseBox/Card/next.bbcode_text = ""
	$PurchaseBox/Card/cost_static.text = ""
	$PurchaseBox/Card/cost.text = ""
	$PurchaseBox/Card/amount_input.value = 1
	$PurchaseBox/Card/btn_confirm_buy.show()
	$PurchaseBox/Card/cost.show()
	var obj = itm.name.split('_', false, 1)
	var type = obj[0]
	var name = obj[1]
	var text
	var text2
	match type:
		"upgrade": #timemachine
			$PurchaseBox/Card/upgrade_arrow.show()
			var alias
			match name:
				"foglamp":
					alias = "Lampu Kabut"
				"timecontrol":
					alias = "Pengendali Waktu"
				"radar":
					alias = "Radar"
			$PurchaseBox/Card/head.text = "Tingkatkan "+alias
			var cost = itm.get_child(1).text
			var tier  = get_u_tier()[name]
			var maxtier = (get_u_price()[name][0]).size()
			if (tier == 0):
				text = "Tidak memiliki fungsi khusus"
				text2 = get_u_price()[name][1][tier]
			elif (tier <= maxtier-2):
				text = get_u_price()[name][1][tier-1]
				text2 = get_u_price()[name][1][tier]
			else: 
				text = get_u_price()[name][1][maxtier-1]
				text2 = "Peningkatan maksimal"
			$PurchaseBox/Card/desc/Label.text  = ''
			$PurchaseBox/Card/desc.bbcode_text = "\n[center][color=#7a8b93]Semula:[/color][/center]\n\n"+text
			$PurchaseBox/Card/next.bbcode_text = "[center][color=#15ab5c]Setelah ditingkatkan:[/color][/center]\n\n"+text2
			$PurchaseBox/Card/cost.text = cost
			set_shop_cart(["timemachine", name, int(cost), 1])
		"power": #powerup
			$PurchaseBox/Card/amount_input.show()
			$PurchaseBox/Card/head.text = name
			var cost = itm.get_child(1).text
			#$PurchaseBox/Card/desc/Label.text  = name 
			$PurchaseBox/Card/desc.bbcode_text = "\n"+item.get_item_byname(name)[2]
			$PurchaseBox/Card/cost_static.text = cost
			$PurchaseBox/Card/cost.text = cost
			var amount = $PurchaseBox/Card/amount_input.value
			set_shop_cart(["powerup", item.get_item_byname(name)[0], int(cost), amount])
		"item":
			$PurchaseBox/Card/head.text = name
			#$PurchaseBox/Card/desc/Label.text  = name 
			$PurchaseBox/Card/btn_confirm_buy.hide()
			$PurchaseBox/Card/cost.hide()
			$PurchaseBox/Card/desc.bbcode_text = "\n"+item.get_item_byname(name)[2]
			pass
	
	#tampilin UI konfirmasi
	$Deselect.show()
	$PurchaseBox.show()

func _on_amount_increase(value):
	var initial = $PurchaseBox/Card/cost_static.text
	$PurchaseBox/Card/cost.text = str(int(initial)*value)
	mod_shop_cart(value)
	
	

##########
# SETGET #
##########
func set_player(args):
	player = args
func get_player():
	return player
func set_u_price(args):
	u_price = args
func get_u_price():
	return u_price
func set_u_tier(args):
	u_tier = args
func get_u_tier():
	return u_tier
func set_shop_cart(args):
	shop_cart = args
func mod_shop_cart(value):
	var temp = shop_cart
	temp[3] = value
	shop_cart = temp
func get_shop_cart():
	return shop_cart

func _open_crafting():
	$CraftingMenu.show()

func _on_btn_off():
	$off.show()

func _on_cancel_off():
	$off.hide()
func _on_accept_off():
	get_tree().quit()
