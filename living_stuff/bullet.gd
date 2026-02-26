extends RigidBody2D
var evil
@export var speed = Vector2(0, -500)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
