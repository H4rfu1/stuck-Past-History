extends Node2D

var collision_pos = []

var artefactzone = true
var artefact_tiles = [
	[1,0], [2,0], [3,0],
	[1,1], [3,1],
	[1,2], [3,2] ]

func _process(delta):
	var cpos = $TileMap.world_to_map($Ysort/player.position)
	$CanvasLayer/Label.text = str(cpos)
	var mpos = $TileMap.world_to_map(get_global_mouse_position())
	$CanvasLayer/Label2.text = str(mpos)
	if (artefactzone):
		_player_on_artefact_zone()
		_artefact_zone_checker()
	#print($TileMap.get_cellv($TileMap.world_to_map(get_global_mouse_position())))

func _player_on_artefact_zone():
	var cpos = $TileMap.world_to_map($Ysort/player.position)
	var tile = $TileMap.get_cellv(cpos)
	yield(get_tree().create_timer(.2), "timeout")
	if tile > 0:
		$TileMap.set_cellv(cpos, tile-1)
	#$TileMap.set_cellv(tile_pos, tile-1)

func _artefact_zone_checker():
	var arteract_tiles_amount = artefact_tiles.size()
	var green = 0
	for t in artefact_tiles:
		t = Vector2(t[0], t[1])
		var tile = $TileMap.get_cellv(t)
		if (tile == 0):
			$CanvasLayer/indicator.text = "Ulangi"
			break #emit signal
		elif (tile > 0 && tile <15):
			green += 1
			if (green == arteract_tiles_amount):
				$CanvasLayer/indicator.text = "Menang"
				break #emit signal
	green = 0


func _on_player_collided(collision):
	if collision.collider is TileMap:
		var tile_pos = collision.collider.world_to_map($Ysort/player.position)
		print(collision.normal)
		tile_pos -= collision.normal  # Colliding tile
		var tile = collision.collider.get_cellv(tile_pos)
		if tile > 0:
			$TileMap.set_cellv(tile_pos, tile-1)
