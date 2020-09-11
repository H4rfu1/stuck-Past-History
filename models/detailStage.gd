extends Node

onready var DB      = load("res://script/plugins/DBconnection.gd").new()
onready var Helper  = preload("res://script/plugins/DBhelper.gd").new()
var local           = preload("res://script/plugins/DBlocal.gd").new()

var stage setget set_stage, get_stage
var artefact_player_pos setget set_p_pos, get_p_pos
var artefact_tiles setget set_a_tiles, get_a_tiles

func _ready():
	set_stage(DB.readJSON("stage_detail"))

func get_player_artefact():
	_ready()
	var stage = GlobalVar.get_stage()
	var jilid = GlobalVar.get_jilid()
	for i in range(0, get_stage().size()):
		var record = get_stage()[i]
		#print (get_stage())
		#print('record partS', record['stage'], ":",stage)
		#print('record partJ', record['jilid'], ":",jilid)
		if(jilid == record['jilid'] && stage == record['stage']):
			return(record['artefact_player_pos'])

func get_tiles_artefact():
	_ready()
	var stage = GlobalVar.get_stage()
	var jilid = GlobalVar.get_jilid()
	for record in get_stage():
		if(jilid == record['jilid'] && stage == record['stage']):
			return(record['artefact_tiles'])

func set_stage(args):
	stage = args
func get_stage():
	return stage

func set_p_pos(args):
	artefact_player_pos = args
func get_p_pos():
	return artefact_player_pos
func set_a_tiles(args):
	artefact_tiles = args
func get_a_tiles():
	return artefact_tiles
