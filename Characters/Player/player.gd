extends CharacterBody2D
class_name Player

@export var health_component: HealthComponent
@export var hurtbox_component: HurtboxComponent

@export var state_manager: StateManager
@export var state_died: State
@export var state_hurt: State

func _ready() -> void:
	hurtbox_component.hit_received.connect(_on_hit_received)
	health_component.died.connect(_on_died)

func _on_hit_received(hitbox: HitboxComponent) -> void:
	health_component.take_damage(hitbox.damage)
	if health_component.current_health > 0:
		# Here the owner decides the rest: switch to the Hurt state,
		# apply knockback using hitbox.knockback_force, start invulnerability...
		state_manager.change_state(state_hurt)

func _on_died() -> void:
	state_manager.change_state(state_died)
