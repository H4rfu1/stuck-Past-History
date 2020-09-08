extends Control

var item            = load("res://models/itemManager.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture
	texture = item.get_item_byid(4)[4]
	$window/Control/ItemA/cost.hide()
	$window/Control/ItemA/icon.texture = load(texture)
	$window/Control/ItemA/own.text = "Punya: "+str(item.owned_item_id(4))
	
	texture = item.get_item_byid(5)[4]
	$window/Control/ItemB/cost.hide()
	$window/Control/ItemB/icon.texture = load(texture)
	$window/Control/ItemB/own.text = "Punya: "+str(item.owned_item_id(5))
	
	texture = item.get_item_byid(6)[4]
	$window/Control/ItemC/cost.hide()
	$window/Control/ItemC/icon.texture = load(texture)
	$window/Control/ItemC/own.text = "Punya: "+str(item.owned_item_id(6))
	
	texture = item.get_item_byid(7)[4]
	$window/Control/ItemResult/cost.hide()
	if(item.owned_item_id(7) == 0):
		$window/Control/ItemResult/own.hide()
	$window/Control/ItemResult/icon.texture = load(texture)
	$window/Control/ItemResult/own.text = "Punya: "+str(item.owned_item_id(7))

func _on_close_crafting():
	get_node(".").hide()

func _on_Klaim():
	var A = item.owned_item_id(4)
	var B = item.owned_item_id(5)
	var C = item.owned_item_id(6)
	if( A > 0 && B > 0 && C > 0):
		item.remove_item(4,1)
		item.remove_item(5,1)
		item.remove_item(6,1)
		item.add_item(7,1)
		print("crafted")
	else:
		print("fail")
	_ready()
