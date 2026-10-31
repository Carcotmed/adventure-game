extends State

@export var state_idle: State
@export var hurtbox_component: HurtboxComponent
@onready var sprite: AnimatedSprite2D = %Sprite

func enter() -> void:
	sprite.play("roll")
	parent.set_collision_mask_value(3, false)
	hurtbox_component.set_deferred("monitoring", false)
	sprite.animation_finished.connect(_roll_finished)
	parent.velocity = parent.velocity.normalized() * Constants.PLAYER_ROLL_SPEED
	
func on_physics_process(delta: float) -> void:
	parent.move_and_slide()
	
func _roll_finished() -> void:
	state_manager.change_state(state_idle)
	parent.set_collision_mask_value(3, true)
	hurtbox_component.set_deferred("monitoring", true)
	sprite.animation_finished.disconnect(_roll_finished)
