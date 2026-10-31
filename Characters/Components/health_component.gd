class_name HealthComponent
extends Node

signal health_changed(old_value: int, new_value: int)
signal died

@export var max_health: int = 3

var current_health: int
var _dead := false

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	if _dead:
		return
	_set_health(current_health - amount)

func heal(amount: int) -> void:
	if _dead:
		return
	_set_health(current_health + amount)

func _set_health(value: int) -> void:
	var new_value := clampi(value, 0, max_health)
	if new_value == current_health:
		return
	var old_value := current_health
	current_health = new_value
	health_changed.emit(old_value, new_value)
	if current_health == 0:
		_dead = true
		died.emit()
