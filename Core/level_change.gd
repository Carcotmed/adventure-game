class_name LevelChange
extends Area2D

@export var source_connection: StringName
@export_file("*.tscn") var target_level: String   # String, no PackedScene (evita dependencia cíclica)
@export var target_connection: StringName

@onready var spawn_point: SpawnMarker = $SpawnMarker  # fuera del área, hacia donde aparece el jugador


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		set_deferred("monitoring", false)  # evita dobles disparos
		LevelManager.change_level.call_deferred(target_level, {"entry": target_connection})
