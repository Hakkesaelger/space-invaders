extends Node

@export_file var level_select

func _ready() -> void:
	$Level/MainMenu/SelectButton.level = level_select
