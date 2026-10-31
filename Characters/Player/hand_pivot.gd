class_name HandPivot
extends Marker2D

var should_flip: bool = false
@onready var sprite: AnimatedSprite2D = %Sprite
@export var weapon: Weapon

var follow_mouse: bool = true

func _ready() -> void:
	weapon.attacking.connect(_on_weapon_attacking)
	weapon.attack_finished.connect(_on_weapon_attack_finished)

func _process(delta: float) -> void:
	if follow_mouse:
		var angle = get_angle_to(get_global_mouse_position())
		rotate(angle + PI/2)
		should_flip = global_rotation < 0
		sprite.flip_h = should_flip
		z_index = 0 if should_flip else 2

func _on_weapon_attacking() -> void:
	follow_mouse = false

func _on_weapon_attack_finished() -> void:
	follow_mouse = true
