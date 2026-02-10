extends Area2D

var attacks: Array = []
@export var time_until_special_attack = 5
var countdown_to_special_attack = time_until_special_attack
var special_attack: Callable

var process: Callable

func _process(delta: float) -> void:
	process.call(delta)

func attack_pattern() -> void:
	while true:
		if countdown_to_special_attack >= 0:
			countdown_to_special_attack -= 1
			var attack: Callable = attacks.pick_random()
			await attack.call()
		else:
			await special_attack.call()
			countdown_to_special_attack = time_until_special_attack
