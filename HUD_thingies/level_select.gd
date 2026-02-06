extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Level1.disabled = false
	if PlayerInformation.beaten_level("one"):
		$Level2.disabled = false
