class_name Map
extends BaseLevel

@onready var player_spawn_marker: PlayerSpawnMarker = %PlayerSpawnMarker
@onready var entity_root: Node2D = %EntityRoot

func get_default_player_spawn() -> Vector2:
	return player_spawn_marker.global_position

func get_entity_root() -> Node2D:
	return entity_root
