class_name LootTableComponent
extends Node

@export var health_component: HealthComponent

func _ready() -> void:
	health_component.died.connect(_on_health_component_died)

func _on_health_component_died() -> void:
	#TODO
	pass # Replace with function body.
