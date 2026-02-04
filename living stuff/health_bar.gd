extends ColorRect

signal boss_dead
var health: int = 20

func _on_boss_body_entered(body: Node2D) -> void:
	if not body.evil:
		size.x -= 16
		health -= 1
	if health <= 0:
		boss_dead.emit()
