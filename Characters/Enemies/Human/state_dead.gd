extends State

@export var hurtbox_component: HurtboxComponent
@export var hitbox_component: HitboxComponent
@export var invincibility_frames_component: InvincibilityFramesComponent

func enter() -> void:
	hitbox_component.set_deferred("monitorable", false)
	#hurtbox_component.set_deferred("monitoring", false)
	invincibility_frames_component.stop()
