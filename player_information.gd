extends Node

var player: Area2D

var levels_beaten: Array = []

func beat_level(level: StringName) -> void:
	levels_beaten.append(level)

func beaten_level(level: StringName) -> bool:
	return levels_beaten.has(level)

func get_player_position():
	return player.position.x
