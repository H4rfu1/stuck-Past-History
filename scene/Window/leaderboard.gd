extends Control

onready var DB      = load("res://script/plugins/DBconnection.gd").new()
onready var Helper  = preload("res://script/plugins/DBhelper.gd").new()
const click_sound = preload("res://scene/Music and Sounds/click.tscn")

func _ready():
	pass # Replace with function body.

func _on_btn_close_pressed():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	$".".visible = false
