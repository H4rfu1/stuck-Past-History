extends Control

onready var DB      = load("res://script/plugins/DBconnection.gd").new()
onready var Helper  = preload("res://script/plugins/DBhelper.gd").new()

func _ready():
	pass # Replace with function body.

func _on_btn_close_pressed():
	$".".visible = false
