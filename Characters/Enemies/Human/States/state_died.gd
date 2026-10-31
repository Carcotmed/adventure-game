extends State

@onready var sprite: AnimatedSprite2D = %Sprite
@export var hurtbox_component: HurtboxComponent
@export var hitbox_component: HitboxComponent
@export var invincibility_frames_component: InvincibilityFramesComponent
@export var death_sound: SoundEffect

func enter() -> void:
	sprite.play("die")
	AudioManager.play_sfx_at(death_sound, parent.global_position)
	sprite.animation_finished.connect(_on_sprite_animation_finished)
	parent.set_collision_layer_value(3, false)
	hitbox_component.set_deferred("monitorable", false)

func _on_sprite_animation_finished() -> void:
	hurtbox_component.set_deferred("monitoring", false)
	invincibility_frames_component.stop()
