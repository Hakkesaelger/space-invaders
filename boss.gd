extends Area2D

@export var seconds_between_attacks = 1.0
var attacks = []

var process: Callable

func _process(delta: float) -> void:
	process.call(delta)

func attack_pattern():
	while true:
		await get_tree().create_timer(seconds_between_attacks).timeout
		var attack: Callable = attacks.pick_random()
		await attack.call()
