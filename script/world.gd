extends Node2D

var collision_pos = []
	
func _process(delta):
	var cpos = $TileMap.world_to_map($Ysort/player.position)
	$CanvasLayer/Label.text = str(cpos)


func _on_player_collided(collision):
	if collision.collider is TileMap:
		var tile_pos = collision.collider.world_to_map($Ysort/player.position)
		tile_pos -= collision.normal  # Colliding tile
		var tile = collision.collider.get_cellv(tile_pos)
		if tile > 0:
			$TileMap.set_cellv(tile_pos, tile-1)
