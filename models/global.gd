extends Node

var toko = "powerup" setget set_toko, get_toko
var equip = [0,0,0,0] setget set_equip, get_equip
var jilid = 1 setget set_jilid, get_jilid
var stage = "1" setget set_stage, get_stage

func set_toko(args):
	toko = args
func get_toko():
	return toko

func set_equip(args):
	equip = args
func get_equip():
	return equip

func set_jilid(args):
	jilid = args
func get_jilid():
	return jilid

func set_stage(args):
	stage = args
func get_stage():
	return stage
