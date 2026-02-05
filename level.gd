extends Node

signal go_to_menu

func _on_player_dead() -> void:
	get_tree().call_group("mobs","queue_free")
	go_to_menu.emit()
	$MainMenu.show_text("You Died!")

func win(level: StringName):
	PlayerInformation.beat_level(level)
	go_to_menu.emit()
	$MainMenu.show_text("You Win!")
