extends CharacterBody2D

@export var health: int = 5
@export var speed: float = 300.0
@export var bullet_scene: PackedScene = preload("res://Bullet.tscn")  # Load the bullet scene
@export var fire_rate: float = 0.5  # Time between shots
@export var bullet_speed: float = 600.0

signal player_died

var fire_timer
var mag = {}

func _ready() -> void:
	fire_timer = $Timer
	#fire_timer.timeout.connect(func reload(): return 1 + 1)


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		print("shoot")
		if fire_timer.time_left == 0: 
			print(fire_timer.time_left)
			shoot_bullet()
			fire_timer.start(fire_rate)


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()


func shoot_bullet() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = position
	bullet.set_direction((get_global_mouse_position() - bullet.global_position).normalized())
	bullet.speed = bullet_speed
	get_tree().current_scene.add_child(bullet)


func create_magazine():
	for i in range(15):
		mag["b" + str(i)] = bullet_scene.instantiate()
	
	print(mag)


func take_damage(amount: int) -> void:
	health -= amount
	print("hurt")
	if health <= 0:
		game_over()

func game_over() -> void:
	# Example: Print game over message and reset the scene
	print("Game Over")
	#get_tree().reload_current_scene()
	player_died.emit()
