class_name CameraFocus
extends RefCounted

var objective: Node2D
var time_left: float = INF
var speed: float

func _init(objective: Node2D, time: float = INF, speed: float = 10) -> void:
	self.objective = objective
	self.time_left = time
	self.speed = speed
