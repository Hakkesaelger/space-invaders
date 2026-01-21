extends Area2D

signal dead
var velocity
@export var speed: int = 300
@export var bullet_scene: PackedScene
var attackCooldownOver = true

func _process(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("left"):
		velocity.x -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
	
	position += velocity * delta
	
	var screen_size = get_viewport_rect().size
	position.x = clampf(position.x, 0, screen_size.x)
	if Input.is_action_just_pressed("shoot") and attackCooldownOver:
		$AttackCooldown.start()
		attackCooldownOver = false
		var bullet = bullet_scene.instantiate()
		var bullet_position = position
		bullet_position.y -= 35
		bullet.position = bullet_position
		bullet.evil = false
		add_sibling(bullet)

func _on_main_menu_new_game():
	show()
	$CollisionShape2D.set_deferred("disabled", false)

func _on_attack_cooldown_timeout() -> void:
	attackCooldownOver = true


func _on_body_entered(body: Node2D) -> void:
	if body.evil:
		die()

func die():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	dead.emit()

func _on_area_entered(_area: Area2D) -> void:
	die()

func _on_enemy_left_screen():
	die()
