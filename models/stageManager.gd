extends Node

onready var DB      = load("res://script/plugins/DBconnection.gd").new()
onready var Helper  = preload("res://script/plugins/DBhelper.gd").new()
var local           = preload("res://script/plugins/DBlocal.gd").new()

var jilid setget set_jilid, get_jilid
var stage setget set_stage, get_stage

func _ready():
	set_jilid(DB.readJSON("jilid"))
	set_stage(DB.readJSON("stage"))

func get_stage_data():
	_ready()
	return get_stage()

func get_stage_bynumber(jilid, number):
	_ready()
	for stage in get_stage_data():
		if (stage[1] == jilid && stage[2] == number):
			return stage

func get_high_score(jilid, number):
	_ready()
	for stage in get_stage_data():
		if (stage[1] == jilid && stage[2] == number):
			return stage[5]

func set_high_score(jilid, stage, score):
	_ready()
	var clone = []
	for record in get_stage_data():
		if (record[1] == jilid && record[2] == stage):
			record[5] = score
		clone.append(record)
	DB.saveJSON(clone, "stage")
	return true

func set_complete_stage(jilid, stage):
	_ready()
	var clone = []
	for record in get_stage_data():
		if (record[1] == jilid && record[2] == stage):
			record[6] = "berhasil"
		clone.append(record)
	DB.saveJSON(clone, "stage")
	return true

func first_complete_stage(jilid, stage):
	_ready()
	var clone = []
	for record in get_stage_data():
		if (record[6] == 'berhasil'):
			return false
		else:
			return true
	return false

func set_stage(args):
	stage = args
func get_stage():
	return stage
func set_jilid(args):
	jilid = args
func get_jilid():
	return jilid
