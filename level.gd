extends Node

@export var mob_scene: PackedScene
@export var boss_scene: PackedScene
signal go_to_menu

func _on_player_dead() -> void:
	get_tree().call_group("mobs","queue_free")
	go_to_menu.emit()
	$MainMenu.show_text("You Died!")


func _on_main_menu_new_game():
	get_tree().call_group("mobs","queue_free")
	$Player.position = $PlayerSpawnPosition.position
	for i in range($EnemySpawners.get_child_count()):
		var mob: Area2D = mob_scene.instantiate()
		$EnemyContainer.add_child(mob)
		mob.position = $EnemySpawners.get_child(i).position
		mob.all_dead.connect(_on_enemy_all_dead)
		mob.left_screen.connect($Player._on_enemy_left_screen)
		if i >= 10:
			mob.move_right = -1

func _on_enemy_all_dead():
	var boss: Node2D = boss_scene.instantiate()
	await get_tree().create_timer(1).timeout
	add_child(boss)
	$BossOne/Boss/Sprite2D.position = $BossSpawnPosition.position
	$BossOne/Boss/CollisionShape2D.position = $BossSpawnPosition.position
	await get_tree().create_timer(1).timeout
	$BossOne/Boss.attack_pattern()
	$BossOne/Boss/Sprite2D/HealthBar.boss_dead.connect(_on_boss_boss_dead)
#	go_to_menu.emit()
#	$MainMenu.show_text("You Win!")

func _on_boss_boss_dead():
	print()
	$BossOne.queue_free()
	go_to_menu.emit()
	$MainMenu.show_text("You Win!")
