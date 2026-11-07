extends State

@onready var sprite: AnimatedSprite2D = %Sprite
@export var weapon: Weapon
@export var hurtbox_component: HurtboxComponent
@export var invincibility_frames_component: InvincibilityFramesComponent

func enter() -> void:
	sprite.animation_finished.connect(_on_sprite_animation_finished)
	sprite.play("die")
	weapon.set_process(false)
	weapon.set_deferred("visible", false)
	hurtbox_component.set_deferred("monitoring", false)
	invincibility_frames_component.stop()

func _on_sprite_animation_finished() -> void:
	#GameManager.load_die_menu()
	pass
