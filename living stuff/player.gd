extends Area2D

signal dead
var velocity: Vector2
@export var movement_speed: int = 300
@export var bullet_scene: PackedScene
var attack_cooldown_over: bool = true
var attack_side: int = 32

func _ready():
	$AnimatedSprite2D.play("idle")

func _process(_delta):
	if Input.is_action_just_pressed("shoot") and attack_cooldown_over:
		$AttackCooldown.start()
		attack_cooldown_over = false
		var bullet: RigidBody2D = bullet_scene.instantiate()
		var bullet_position: Vector2 = position
		bullet_position.y -= 35
		bullet_position.x += attack_side
		attack_side *= -1
		bullet.position = bullet_position
		bullet.evil = false
		add_sibling(bullet)
		$AnimatedSprite2D.play("shoot right")
		if attack_side > 0:
			$AnimatedSprite2D.play("shoot left")

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	velocity.x += Input.get_axis("left","right") * movement_speed
	
	
	position += velocity * delta
	
	var screen_size: Vector2 = get_viewport_rect().size
	position.x = clampf(position.x, 0, screen_size.x)
	

func _on_main_menu_new_game():
	show()
	$CollisionShape2D.set_deferred("disabled", false)

func _on_attack_cooldown_timeout() -> void:
	attack_cooldown_over = true


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


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("idle")
