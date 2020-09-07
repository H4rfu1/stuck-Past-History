extends Node2D

var player_data = preload('res://models/playerManager.gd').new()
var use_equip   = preload('res://script/UseEquip.gd').new()

var collision_pos = []
var player = .get_node("Ysort/player")

var complete = false
export var TIME_PERIOD = 60
var time = 0
var stats = PlayerStats

onready var timerStage = $TimerStage

onready var audio_game = get_node("/root/GamePlay")

var artefactzone = false setget setZoneState, getZoneState
var artefact_tiles = [
	[1,0], [2,0], [3,0],
	[1,1], [3,1],
	[1,2], [3,2] ]
var artefact_player_pos = [2,3]
#func _draw():
#	var object = get_node("Ysort/Stone/StaticBody2D").global_position
#	var from =  get_node("Ysort/player").global_position
#	draw_line(Vector2(322.44101, -42.426399), Vector2(500, 500), Color(255, 0, 0), 1)
#	print(object)
#	print(from)
func _ready():
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

func _on_player_collided(collision):
	if collision.collider is TileMap:
		var tile_pos = collision.collider.world_to_map($Ysort/player.position)
		print(collision.normal)
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
	for t in artefact_tiles:
		t = Vector2(t[0], t[1])
		var tile = $TileZone.get_cellv(t)
		if (tile == 0):
			artefact_zone_restore()
			break #emit signal
		elif (tile > 0 && tile <7):
			green += 1
			if (green == arteract_tiles_amount && complete == false):
				complete = true
				timerStage.paused = true
				#menang/waktu_habis/coba_lagi, score = 0, waktu = 0, uang = 0
				var rtime  = $CanvasLayer/TimeLabel.text
				var time   = int(rtime)
				var health = PlayerStats.get_heath()
				var score  = (50*health)+(10*time)
				var coin   = (arteract_tiles_amount*15*time)+(50*health)
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
	for btn in $CanvasLayer/UI/HUD_Item/equip.get_children():
		if(equip[i] == 0):
			btn.hide()
		else:
			btn.get_child(1).hide()
			var icon = item.get_item_byid(equip[i])[4]
			var amount = "Punya: "+ str(GlobalVar.get_lim_equip()[i])
			if(i == 0):
				icon = "res://assets/img/upgrade_radar.png"
				if (equip[0] == 0):
					btn.hide()
				amount = "Batas: "+ str(GlobalVar.get_lim_equip()[0])
			btn.get_child(0).texture = load(icon)
			btn.get_child(2).text = amount
			
		i +=1
	use_equip._run_connector()

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
	$CanvasLayer/game_result2.create("waktu_habis", 9000, "0:11", 500)
