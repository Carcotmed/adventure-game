class_name KnockbackComponent
extends Node

@export var parent: PhysicsBody2D
@export var hurtbox_component: HurtboxComponent

func _ready() -> void:
	hurtbox_component.hit_received.connect(_on_hurtbox_component_hit_received)

func _on_hurtbox_component_hit_received(hitbox: HitboxComponent) -> void:
	var knockback_direction := hitbox.global_position.direction_to(parent.global_position)
	parent.velocity = hitbox.knockback_force * knockback_direction
