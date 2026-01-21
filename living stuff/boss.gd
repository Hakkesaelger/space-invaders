extends Area2D

var attacks = [hole_in_the_wall, bullet_circle, summon_reinforcements]
@export var bullet_scene: PackedScene
@export var bullet_amount = 10
@export var seconds_between_attacks = 1.0
@export var attack_stick_speed = 300
@export var mob_scene: PackedScene
@export var reinforcements = 3
var positions = [110, 220, 330, 440, 550, 660, 770, 880, 990]
var used_positions = []

func move_attack_sticks(delta):
	$AttackPivot.position.y += attack_stick_speed * delta
func do_nothing(_delta):
	pass

var process: Callable = do_nothing

func hole_in_the_wall():
	var random_pos = randi() % 550 - 200
	$AttackPivot/AttackStick.position.x = random_pos
	$AttackPivot/AttackStick2.position.x = random_pos + 1200
	$AttackPivot.show()
	process = move_attack_sticks
	await get_tree().create_timer(2).timeout
	$AttackPivot.hide()
	$AttackPivot.position.y = 0
	process = do_nothing

func bullet_circle():
	var firstBullet = randi() % 360
	@warning_ignore("integer_division")
	for i in range(firstBullet, 360 + firstBullet, 360 / bullet_amount):
		var bullet := bullet_scene.instantiate()
		bullet.evil = true
		bullet.speed = bullet.speed.rotated(deg_to_rad(i))
		bullet.position = $Sprite2D.position
		add_sibling(bullet)
	await get_tree().create_timer(1).timeout

func summon_reinforcements():
	if len(used_positions) == len(positions):
		return
	for i in range(reinforcements):
		var place
		var mob: Area2D = mob_scene.instantiate()
		$MobContainer.add_child(mob)
		while true:
			place = positions.pick_random()
			if not used_positions.has(place):
				break
		used_positions.push_front(place)
		mob.position = Vector2(place + randi() % 20 -10, 228)
		mob.all_dead.connect(_on_mob_all_dead)
	$Sprite2D.hide()
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(4).timeout

func _on_mob_all_dead():
	$Sprite2D.show()
	$CollisionShape2D.set_deferred("disabled",false)
	used_positions = []

func _process(delta: float) -> void:
	process.call(delta)

func attack_pattern():
	while true:
		await get_tree().create_timer(seconds_between_attacks).timeout
		var attack: Callable = attacks.pick_random()
		await attack.call()
