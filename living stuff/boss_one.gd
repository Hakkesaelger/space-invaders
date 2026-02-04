extends Node2D

@export var bullet_scene: PackedScene
@export var bullet_amount: int = 10
@export var attack_stick_speed: int = 300
@export var mob_scene: PackedScene
@export var reinforcements: int = 3
var positions: Array = [110, 220, 330, 440, 550, 660, 770, 880, 990]
var used_positions: Array = []
@export var attack_stick_random_distance_from_player: int = 350

func _ready():
	$Boss.process = do_nothing
	$Boss.attacks = [hole_in_the_wall, bullet_circle, summon_reinforcements]

func move_attack_sticks(delta):
	$Boss/AttackPivot.position.y += attack_stick_speed * delta
func do_nothing(_delta):
	pass

func hole_in_the_wall():
	var random_pos: int = get_parent().get_node("Player").position.x
	#The hole is centered on the player
	random_pos += randi() % (2 * attack_stick_random_distance_from_player) - attack_stick_random_distance_from_player
	#Add some randomization
	random_pos = clampi(random_pos, 200, 1000)
	#Clamp it to a reasonable number
	$Boss/AttackPivot.position.x = random_pos
	$Boss/AttackPivot.show()
	$Boss.process = move_attack_sticks
	await get_tree().create_timer(2).timeout
	$Boss/AttackPivot.hide()
	$Boss/AttackPivot.position.y = 0
	$Boss.process = do_nothing

func bullet_circle():
	var firstBullet: int = randi() % 360
	@warning_ignore("integer_division")
	for i in range(firstBullet, 360 + firstBullet, 360 / bullet_amount):
		var bullet: RigidBody2D = bullet_scene.instantiate()
		bullet.evil = true
		bullet.speed = bullet.speed.rotated(deg_to_rad(i))
		bullet.position = $Boss/Sprite2D.position
		add_sibling(bullet)
	await get_tree().create_timer(1).timeout

func summon_reinforcements():
	if len(used_positions) == len(positions):
		return
	for i in range(reinforcements):
		var place: int
		var mob: Area2D = mob_scene.instantiate()
		$Boss/MobContainer.add_child(mob)
		while true:
			place = positions.pick_random()
			if not used_positions.has(place):
				break
		used_positions.push_front(place)
		mob.position = Vector2(place + randi() % 20 -10, 228)
		mob.all_dead.connect(_on_mob_all_dead)
	$Boss/Sprite2D.hide()
	$Boss/CollisionShape2D.disabled = true
	await get_tree().create_timer(4).timeout
func _on_mob_all_dead():
	$Boss/Sprite2D.show()
	$Boss/CollisionShape2D.set_deferred("disabled",false)
	used_positions = []
