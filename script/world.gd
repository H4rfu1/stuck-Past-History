extends Node2D

var player_data  = load('res://models/playerManager.gd').new()
var stage_detail = load('res://models/detailStage.gd').new()
var use_equip    = load('res://script/UseEquip.gd').new()

#audio
const timeout = preload("res://scene/Music and Sounds/gong.tscn")
const win = preload("res://scene/Music and Sounds/win.tscn")

var collision_pos = []
onready var player = .get_node("Ysort/player")
onready var mob = .get_node("Ysort/Mob")

var complete = false
var TIME_PERIOD = GlobalVar.get_gametime()
export var health = 3
export var tipe_baju = "jawa"
var time = 0
var stats = PlayerStats
var status = true

onready var timerStage = $TimerStage

onready var audio_game = get_node("/root/GamePlay")

var artefactzone = false setget setZoneState, getZoneState
var artefact_tiles setget set_a_tiles
var artefact_player_pos setget set_p_pos
#var artefact_tiles = [
#	[1,0], [2,0], [3,0],
#	[1,1], [3,1],
#	[1,2], [3,2] ]
#var artefact_player_pos = [2,3]
#func _draw():
#	var object = get_node("Ysort/Stone/StaticBody2D").global_position
#	var from =  get_node("Ysort/player").global_position
#	draw_line(Vector2(322.44101, -42.426399), Vector2(500, 500), Color(255, 0, 0), 1)
#	print(object)
#	print(from)
func set_p_pos(args):
	artefact_player_pos = args
func get_p_pos():
	return artefact_player_pos
func set_a_tiles(args):
	artefact_tiles = args
func get_a_tiles():
	return artefact_tiles

func _ready():
	set_a_tiles(stage_detail.get_tiles_artefact())
	set_p_pos(stage_detail.get_player_artefact())
	print('ptil',artefact_tiles)
	print('pptil',artefact_player_pos)
	stage_detail.get_player_artefact()
	if GlobalVar.get_mode() == "0-1":
		$CanvasLayer/slide/tap2.play("play")
		$CanvasLayer/slide2/tap2.play("play")
		$CanvasLayer/slide3/tap2.play("play")
		$CanvasLayer/slide4/tap2.play("play")
		timerStage.paused = true
		$CanvasLayer/dialog_window.show()
		$CanvasLayer/dialog_window.create(["Petunjuk: \n1. Nyawa player, akan berkurang apabila tertangkap penduduk asli dan terkena jebakan\n2. Batas waktu menyelesaikan misi\n3. Kontroler pergerakan player\n4. Pause game dan pengaturan","Petunjuk: \nikuti garis bantu\nsetelah masuk dalam area artefak, lewati seluruh block photo untuk menyelesaikan misi\nHati-hati dengan jebakan dan penduduk sekitar"])
	elif GlobalVar.get_mode() == "0-2":
		$CanvasLayer/tap2d2/tap2.play("play")
		$CanvasLayer/dialog_window.show()
		$CanvasLayer/dialog_window.create(["Petunjuk: \nTap untuk menggunakan skill.\nSama seperti stage sebelumnya, potret setiap sisi untuk menyelesaikan misi.\nHati-hati jangan sampai tertangkap penduduk dan terkena jebakan"])
	
	var audio = "not played"
	stats.status = "ongoing"
	GlobalVar.set_baju(tipe_baju)
	#set phycical to true
	$"Ysort/player".set_physics_process(true)
	$"Ysort/player".set_collision_layer_bit( 2, true)
	var mob = get_node("Ysort/Mob")
	for node in mob.get_children():
		node.set_physics_process(true)
	
	#set player health
	stats.set_health(health)
	$TileZone.hide()
	GlobalVar.init_limit_equip()
	_starter()

func _starter():
	adjust_control()
	timerStage.set_wait_time( TIME_PERIOD )
	timerStage.connect("timeout",self,"_on_timerStage_timeout") 
#	add_child(timerStage) #to process
	timerStage.start() #to start
	$CanvasLayer/game_result2.hide()
	render_equip()

func normalize_time(raw):
	raw = round(raw)
	if(raw >= 60):
		var minutes = int(raw)/60
		var seconds = int(raw) - 60
		return str(minutes)+"m "+str(seconds)+"d"
	return str(raw)+"d"

func _process(delta):
	update()
	adjust_control()
	var cpos = $TileZone.world_to_map($Ysort/player.position)
	$CanvasLayer/Label.text = str(cpos)
	var mpos = $TileZone.world_to_map(get_global_mouse_position())
	$CanvasLayer/Label2.text = str(mpos)
	$CanvasLayer/TimeLabel.text = normalize_time($TimerStage.get_time_left())
	if !stats.status == "ongoing":
		timerStage.paused = true
	
	if( $TileZone.get_cellv(cpos) == 9):
		setZoneState(true)
		artefact_zone_blocker(cpos)
		
	if (getZoneState()):
		player_on_artefact_zone()
		artefact_zone_checker()
	if(timerStage.time_left < 50 and status == true and GlobalVar.get_mode() == "0-2"):
		$CanvasLayer/tap2d2/tap2.play("stop")
		status = false
	#animation 0-1_play
	if GlobalVar.get_mode() == "0-1_play":
		$Direction.visible = true
		timerStage.paused = false

func _on_player_collided(collision):
	if collision.collider is TileMap:
		var tile_pos = collision.collider.world_to_map($Ysort/player.position)
		tile_pos -= collision.normal  # Colliding tile
		var tile = collision.collider.get_cellv(tile_pos)
		if tile < 8 and tile > 0:
			$TileZone.set_cellv(tile_pos, tile-1)
#===============
#Artefact things
#===============
func player_on_artefact_zone():
	var cpos = $TileZone.world_to_map($Ysort/player.position)
	var tile = $TileZone.get_cellv(cpos)
	yield(get_tree().create_timer(.2), "timeout")
	if tile < 8 and tile > 0:
		$TileZone.set_cellv(cpos, tile-1)
	elif tile == 9:
		$TileZone.set_cellv(cpos, 8)

func artefact_zone_checker():
	var arteract_tiles_amount = artefact_tiles.size()
	var green = 0
	print('green', green)
	for t in artefact_tiles:
		t = Vector2(t[0], t[1])
		var tile = $TileZone.get_cellv(t)
		if (tile == 0) && stats.status=="ongoing":
			artefact_zone_restore()
			break #emit signal
		elif (tile > 0 && tile <7  && stats.status=="ongoing"):
			green += 1
			if (green == arteract_tiles_amount && complete == false):
				complete = true
				stats.status = "menang"
				var Win = win.instance()
				get_tree().current_scene.add_child(Win)
				print("won")
				timerStage.paused = true
				#menang/waktu_habis/coba_lagi, score = 0, waktu = 0, uang = 0
				var rtime  = $CanvasLayer/TimeLabel.text
				var time   = int(rtime)
				var health = PlayerStats.get_heath()
				var score  = (50*health)+(10*time)
				var coin   = (arteract_tiles_amount*15*time)+(50*health)
				if GlobalVar.get_mode() == "0-1_play":
					GlobalVar.set_mode("tutor_main2")
				if GlobalVar.get_mode() == "0-2":
					GlobalVar.set_mode("selesai_tutor")
					player_data.tutorial_selesai()
				$Ysort/player.hurtbox.set_collision_layer_bit( 2, false)
				$Ysort/player.set_physics_process(false)
				for node in mob.get_children():
					node.set_physics_process(false)
				$CanvasLayer/game_result2.create("menang", score, rtime, 500)
	green = 0

func artefact_zone_blocker(cpos):
	$TileZone.show()
	artefact_zone_restore()
	var t = Vector2(artefact_player_pos[0],artefact_player_pos[1])
	var cpos_str = cpos - Vector2(20, 20)
	var cpos_end = cpos + Vector2(20, 20)
	print()
	for x in range (int(cpos_str.x) , int(cpos_end.x)):
		for y in range (int(cpos_str.y) , int(cpos_end.y)):
			t = Vector2(x, y)
			var tile = $TileZone.get_cellv(t)
			if ( tile == 9 ):
				$TileZone.set_cellv(t, 8)

func artefact_zone_restore():
	var cpos = Vector2(artefact_player_pos[0],artefact_player_pos[1])
	cpos = $TileZone.map_to_world(cpos)
	$Ysort/player.position = cpos + Vector2(32, 32)
	for t in artefact_tiles:
		t = Vector2(t[0], t[1])
		$TileZone.set_cellv(t, 7)

func adjust_control():
	if !audio_game.playing:
		audio_game.play()
	var type = player_data.get_control_type()
	if(type): #keypad
		$CanvasLayer/Joystick.hide()
		$CanvasLayer/Keypad.show()
	else:
		$CanvasLayer/Joystick.show()
		$CanvasLayer/Keypad.hide()

#================
#Equip
#================
func render_equip():
	var item = load("res://models/itemManager.gd").new()
	var equip = GlobalVar.get_equip()
	var i = 0
	var zero_equip = 0
	for btn in $CanvasLayer/UI/HUD_Item/equip.get_children():
		zero_equip +=equip[i]
		if(equip[i] == 0):
			btn.hide()
		else:
			#btn.texture_hover = load('res://assets/UI/window/item_null.png')
			var icon = item.get_item_byid(equip[i])[4]
			var amount = "Punya: "+ str(GlobalVar.get_lim_equip()[i])
			if(i == 0):
				icon = "res://assets/img/upgrade_radar.png"
				if (equip[0] == 0):
					btn.hide()
				amount = "Batas: "+ str(GlobalVar.get_lim_equip()[0])
			btn.get_child(0).texture = load(icon)
			btn.get_child(1).text = amount
		i +=1
	if zero_equip == 0:
		$CanvasLayer/UI/HUD_Item.hide()

#=================
#Setter and Getter
#=================
func setZoneState(args: bool):
	artefactzone = args

func getZoneState():
	return artefactzone

#=================
#Timer
#=================
func _on_timerStage_timeout():
	var Timeout = timeout.instance()
	get_tree().current_scene.add_child(Timeout)
	$CanvasLayer/game_result2.create("waktu_habis", 9000, "0:11", 500)
	$Ysort/player.set_physics_process(false)
	$Ysort/player.hurtbox.set_collision_layer_bit( 2, false)
	stats.status = "timeout"
	for node in mob.get_children():
		node.set_physics_process(false)
