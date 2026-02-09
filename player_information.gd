extends Node

var player_position: Vector2 = Vector2.ZERO

var levels_beaten: Array = []

func beat_level(level: StringName) -> void:
	levels_beaten.append(level)

func beaten_level(level: StringName) -> bool:
	return levels_beaten.has(level)
