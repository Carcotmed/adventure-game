@abstract
class_name BaseMenu
extends Control

var menu_id: StringName

@export var hides_below: bool = true

@abstract
func _on_enter(params: Dictionary) -> void

@abstract
func _on_covered() -> void

@abstract
func _on_uncovered() -> void

@abstract
func _on_exit() -> void
