class_name InvincibilityFramesComponent
extends Timer

@export var sprite: Node2D
@export var hurtbox_component: HurtboxComponent
@export var flicker_hz: float = 10.0
@export var invencibility_seconds: float = 1

func _ready() -> void:
	one_shot = true
	set_process(false)
	timeout.connect(_on_timeout)
	hurtbox_component.hit_received.connect(_on_hurtbox_component_hit_received)

func _process(_delta: float) -> void:
	sprite.visible = int(time_left * flicker_hz * 2.0) % 2 == 0

func _on_hurtbox_component_hit_received(hitbox: HitboxComponent) -> void:
	hurtbox_component.set_deferred("monitoring", false)
	start(invencibility_seconds)
	set_process(true)
	
func _on_timeout() -> void:
	set_process(false)
	sprite.visible = true
	hurtbox_component.set_deferred("monitoring", true)
