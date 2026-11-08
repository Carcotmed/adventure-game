class_name BaseLevel
extends Node

signal finished(result: Dictionary)

var entry_connection: StringName

@export var player_start: SpawnMarker

func _ready() -> void:
	place_player($Player)
	CameraManager.set_default_target($Player)
	CameraManager.snap()


func setup(params: Dictionary) -> void:
	entry_connection = params.get("entry", &"")


func place_player(player: Node2D) -> void:
	# Sin entrada indicada (arranque desde el menú): punto fijo del nivel.
	if entry_connection == &"":
		if player_start:
			player.global_position = player_start.global_position
		return

	for change: LevelChange in find_children("*", "LevelChange", true, false):
		if change.source_connection == entry_connection:
			player.global_position = change.spawn_point.global_position
			return
	push_warning("%s: no existe la conexión '%s'" % [name, entry_connection])
