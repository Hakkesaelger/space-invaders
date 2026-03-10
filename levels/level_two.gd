extends Node

@export var mob_scene: PackedScene

func _on_main_menu_new_game() -> void:
	$Level.set_process(true)
	get_tree().call_group("mobs","queue_free")
	$Level/Player.position = $PlayerSpawnPosition.position
	for i in range($EnemySpawners.get_child_count()):
		var mob: Area2D = mob_scene.instantiate()
		$Level/EnemyContainer.add_child(mob)
		mob.position = $EnemySpawners.get_child(i).position
		mob.left_screen.connect($Level/Player._on_enemy_left_screen)
		if i >= 10:
			mob.move_right = -1

func _on_level_all_dead() -> void:
	$Level.set_process(false)
	$Level.win("two")
