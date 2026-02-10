extends Area2D

signal all_dead
signal left_screen

var movement: float = 0
@export var movement_limit: float = 0.5
@export var move_right: int = 1
@export var movement_speed_side: int = 5
var bullet_progress: float = 0
@export var bullet_scene: PackedScene
var bullet_possibility: float
@export var bullet_chance: float = 0.1
var move_down: bool = false
@export var movement_speed_down: int = 15
var ready_to_shoot: bool = false
var dying: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimatedSprite2D.look_at(PlayerInformation.player_position)
	$AnimatedSprite2D.rotate(PI / 2)
	bullet_progress += delta * bullet_chance
	if ready_to_shoot:
		if bullet_progress > bullet_possibility:
			shoot()
	

func _physics_process(delta: float) -> void:
	if movement >= movement_limit:
		movement = 0
		move_right *= -1
	movement += delta
	position.x += movement_speed_side * move_right * delta
	if move_down:
		position.y += movement_speed_down * delta

func _ready() -> void:
	bullet_possibility = randf()
	await get_tree().create_timer(0.5).timeout
	ready_to_shoot = true


func _on_body_entered(body: Node2D) -> void:
	if not body.evil:
		dying = true
		body.queue_free()
		$CollisionShape2D.set_deferred("disabled",true)
		$AnimatedSprite2D.play("death")
		if get_parent().get_child_count() == 1:
			all_dead.emit()
		queue_free()

func _on_start_moving_timeout() -> void:
	move_down = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	left_screen.emit()

func shoot() -> void:
	bullet_progress = 0
	bullet_possibility = randf() + 1
	if not dying:
		$AnimatedSprite2D.play("shoot")
	await get_tree().create_timer(2).timeout
	var bullet: RigidBody2D = bullet_scene.instantiate()
	var bullet_position: Vector2 = position
	bullet_position.y += 35
	bullet.position = bullet_position
	bullet.evil = true
	get_parent().add_sibling(bullet)
	bullet.rotation = $AnimatedSprite2D.rotation
	bullet.linear_velocity = bullet.linear_velocity.rotated($AnimatedSprite2D.rotation)


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("idle")
