class_name HurtboxComponent
extends Area2D

signal hit_received(hitbox: HitboxComponent)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		hit_received.emit(area)
