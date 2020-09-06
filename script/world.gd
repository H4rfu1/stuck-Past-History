extends Node2D

var player_data = preload('res://models/playerManager.gd').new()

var collision_pos = []
var player = .get_node("Ysort/player")
var timeUI = .get_node("CanvasLayer/UI/Label")

var complete = false
export var TIME_PERIOD = 10
var time = 0

onready var audio_game = get_node("/root/GamePlay")

var artefactzone = false setget setZoneState, getZoneState
var artefact_tiles = [
	[1,0], [2,0], [3,0],
	[1,1], [3,1],
	[1,2], [3,2] ]
var artefact_player_pos = [2,3]

func _ready():
	if !audio_game.playing:
		audio_game.play()
	$TileZone.hide()
	_starter()

func _starter():
	adjust_control()
	var timerStage = $TimerStage
	timerStage.set_wait_time( TIME_PERIOD )
	timerStage.connect("timeout",self,"_on_timerStage_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timerStage) #to process
	timerStage.start() #to start
	$CanvasLayer/game_result2.hide()


func _process(delta):
	var cpos = $TileZone.world_to_map($Ysort/player.position)
	$CanvasLayer/Label.text = str(cpos)
	var mpos = $TileZone.world_to_map(get_global_mouse_position())
	$CanvasLayer/Label2.text = str(mpos)
	$CanvasLayer/TimeLabel.text = str(round($TimerStage.get_time_left()))
	
	time += delta
	if time > TIME_PERIOD:
		# Reset timer
		$CanvasLayer/game_result2.create("waktu_habis", 9000, "0:11", 500)
		time = 0
	#$CanvasLayer/TimeLabel.text = "time :"
	
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
				#menang/waktu_habis/coba_lagi, score = 0, waktu = 0, uang = 0
				$CanvasLayer/game_result2.create("menang", 9000, "0:11", 500)
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
	var type = player_data.get_control_type()
	if(type): #keypad
		$CanvasLayer/Joystick.hide()
		$CanvasLayer/Keypad.show()
	else:
		$CanvasLayer/Joystick.show()
		$CanvasLayer/Keypad.hide()


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
