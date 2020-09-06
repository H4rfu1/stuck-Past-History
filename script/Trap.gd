extends Node2D

func _on_Hitbox_body_entered(body):
	var player = get_parent().get_parent().get_node("player")
	var result = get_parent().get_parent().get_node("CanvasLayer/game_result2")
	result.create("coba_lagi", 9000, "0:11", 500)
