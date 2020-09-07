extends Node

onready var DB      = load("res://script/plugins/DBconnection.gd").new()
onready var Helper  = preload("res://script/plugins/DBhelper.gd").new()
var local           = preload("res://script/plugins/DBlocal.gd").new()

var koleksi setget set_koleksi, get_koleksi
var u_tier setget set_u_tier, get_u_tier
var item setget set_item, get_item
var inventory setget set_inventory, get_inventory

func _ready():
	set_u_tier(DB.readJSON("u_tier"))
	set_koleksi(DB.readJSON("koleksi"))
	set_item(DB.readJSON("item"))
	set_inventory(DB.readJSON("inventory"))

func upgrade_timemachine(type):
	_ready()
	var tier = get_u_tier()[type]
	DB.pushJSON([type], [tier+1], "u_tier")
	print("Item: ", type, " upgraded to ", get_u_tier()[type])

func get_item_tier(name):
	_ready()
	return get_u_tier()[name]

func get_all_item():
	_ready()
	return get_item()
func get_item_byname(name):
	_ready()
	for item in get_all_item():
		if (item[1] == name):
			return item
func get_item_byid(id):
	_ready()
	for item in get_all_item():
		if (item[0] == id):
			return item
func owned_item_id(ids) -> int:
	_ready()
	var amount = 0
	for item in get_inventory():
		if (item[0] == ids):
			amount = item[1]
	return amount
func add_item(index, amount):
	_ready()
	DB.appendJSON([index,amount, "+"], "inventory")
func remove_item(index,amount):
	_ready()
	DB.appendJSON([index,amount, "-"], "inventory")

func get_all_inventory_items():
	_ready()
	var inv = []
	var data = get_inventory()
	for i in data:
		if i[0] == 0:
			pass
		else:
			inv.append(i)
	return inv

func get_all_koleksi():
	_ready()
	return get_koleksi()
func convert_jilid_stage_to_id(jilid,stage):
	_ready()
	for record in get_all_koleksi():
		if (record[1] == str(stage) && record[6] == int(jilid)):
			return record[0]
func check_koleksi(id):
	var koleksi = get_koleksi_byid(id)
	if(koleksi[5] == 1):
		return true
	else:
		return false
func add_koleksi(stage):
	_ready()
	var clone = []
	for record in get_all_koleksi():
		if (record[1] == stage):
			record[5] = 1
		clone.append(record)
	DB.saveJSON(clone, "koleksi")
	return true
func get_koleksi_byid(id):
	_ready()
	for record in get_all_koleksi():
		if (record[0] == id):
			return record
func get_koleksi_bystage(stage):
	_ready()
	for record in get_all_koleksi():
		if (record[1] == stage):
			return record


##########
# SETGET #
##########
func set_u_tier(args):
	u_tier = args
func get_u_tier():
	return u_tier

func set_koleksi(args):
	koleksi = args
func get_koleksi():
	return koleksi
func own_koleksi(index):
	_ready()
	DB.pushJSON([index], [true], "koleksi")

func set_item(args):
	item = args
func get_item():
	return item
func set_inventory(args):
	inventory = args
func get_inventory():
	return inventory
