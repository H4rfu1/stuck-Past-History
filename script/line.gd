extends Node2D


func _draw():
	var object = get_parent().get_node("Ysort/Stone/StaticBody2D").global_position
	var player =  get_parent().get_node("Ysort/player").global_position
	draw_line(player, object, Color(0, 0, 123), 2)
	draw_line(player, object, Color8(255, 255, 255, 125), 6)
#	print(object)
#	print(from)
func _ready():
	pass # Replace with function body.

func _process(delta):
	update()
