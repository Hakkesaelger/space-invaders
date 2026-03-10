extends Node

signal all_dead
@export_file var level_select
signal go_to_menu

func _on_player_dead() -> void:
	set_process(false)
	get_tree().call_group("mobs","queue_free")
	go_to_menu.emit()
	$MainMenu.show_text("You Died!")

func win(level: StringName) -> void:
	PlayerInformation.beat_level(level)
	set_process(false)
	go_to_menu.emit()
	$MainMenu.show_text("You Win!")

func _ready() -> void:
	$MainMenu/SelectButton.level = level_select
	$MainMenu.new_game.connect(get_parent()._on_main_menu_new_game)
	set_process(false)

func _process(_delta: float) -> void:
	if not ($EnemyContainer.get_child_count()): 
		all_dead.emit()
		set_process(false)
