class_name HitboxComponent
extends Area2D

@export var damage: int = 1
@export var knockback_force: float = 70.0

func _ready() -> void:
	# The hitbox only needs to be detected, it doesn't need to detect anything itself.
	monitoring = false
