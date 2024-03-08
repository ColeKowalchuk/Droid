extends Area2D
class_name TerrarinDetector

@onready var PLAYER = get_parent()
@onready var current_tilemap : TileMap = PLAYER.TILEMAP

func refresh_tilemap():
	current_tilemap = get_parent().TILEMAP

func _process_tilemap_collision(body: Node2D, body_rid: RID, approach : bool):
	
	var collided_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
	
	for index in current_tilemap.get_layers_count():
		var tile_data = current_tilemap.get_cell_tile_data(index, collided_tile_coords)
		
		if tile_data:
			
			if approach:
				PLAYER.enter_terrain(tile_data.get_custom_data("PlayerTracks"))
			else:
				PLAYER.leave_terrain(tile_data.get_custom_data("PlayerTracks"))
	
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		_process_tilemap_collision(body, body_rid, true)

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		_process_tilemap_collision(body, body_rid, false)
