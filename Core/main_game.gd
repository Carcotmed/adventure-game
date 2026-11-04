class_name MainGame
extends Node

const PLAYER_SCENE_RES = "res://Characters/Player/Player.tscn"
const MAP = "res://Levels/map.tscn"

@onready var entity_root: Node2D = %EntityRoot
@onready var level_root: Node2D = %LevelRoot
@onready var effect_root: Node2D = %EffectRoot

@onready var hud_layer: CanvasLayer = %HudLayer
@onready var pause_layer: CanvasLayer = %PauseLayer
@onready var transition_layer: CanvasLayer = %TransitionLayer

var player: Player
var _current_level: BaseLevel

func _ready() -> void:
	_init_player()
	load_level(MAP)

func _init_player() -> void:
	var player_scene = ResourceLoader.load(PLAYER_SCENE_RES) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: " + PLAYER_SCENE_RES)
		return
		
	player = player_scene.instantiate()
	if player == null:
		push_error("Loaded player scene does not extend player or DNE: " + PLAYER_SCENE_RES)
		return
		
	entity_root.add_child(player)
	
func load_level(level_scene_res: String) -> void:
	_deferred_load_level.call_deferred(level_scene_res)
	
func _deferred_load_level(level_scene_res: String) -> void:
	if _current_level != null:
		_current_level.queue_free()
		_cleanup_entities()
		_current_level = null
		await get_tree().process_frame
	
	var new_level_packed = ResourceLoader.load(level_scene_res) as PackedScene
	if new_level_packed == null:
		push_error("Could not load level scene: " + level_scene_res)
		return
		
	var new_level = new_level_packed.instantiate()
	
	if not new_level:
		push_error("Could not instantiate new level " + level_scene_res)
		return
	
	if not new_level is BaseLevel:
		push_error("Loaded level is not of type BaseLevel: " + level_scene_res)
		return
		
	_current_level = new_level
		
	level_root.add_child(_current_level)
	
	_place_player_at_level_spawn()
	_load_level_entities()
	#_setup_level_camera()
	
func _place_player_at_level_spawn() -> void:
	player.global_position = _current_level.get_default_player_spawn()
	
func _cleanup_entities() -> void:
	for child in entity_root.get_children():
		if child is not Player:
			child.queue_free()
	
func _load_level_entities() -> void:
	for child in _current_level.get_entity_root().get_children():
		child.reparent(entity_root)
	
#func _setup_level_camera() -> void:
	#var level_camera: Camera2D = _current_level.get_player_camera()
	#level_camera.reparent(player)
