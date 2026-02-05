extends Control

signal new_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_game_button_button_down() -> void:
	new_game.emit()
	hide()


func _on_main_go_to_menu() -> void:
	show()

func show_text(text):
	$Label.text = text
