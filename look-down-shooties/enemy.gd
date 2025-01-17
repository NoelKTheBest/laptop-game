extends CharacterBody2D

@export var health: int = 3
@export var speed: float = 100.0
var player: Node2D
var stop_attack: bool = false

func _ready() -> void:
	# Find the player in the scene
	player = get_tree().get_first_node_in_group("player")
	player.player_died.connect(killed_player)

func _process(delta: float) -> void:
	if player and not stop_attack:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1)


func killed_player():
	print("player is dead")
	stop_attack = true
	queue_free()
