extends Node2D

func _on_Hitbox_body_entered(body):
	var player = get_parent().get_parent().get_node("player")
	player.queue_free()
