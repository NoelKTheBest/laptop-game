extends Area2D

@export var speed: float = 600.0  # Speed of the bullet
@export var lifespan: float = 3.0  # Time before the bullet is removed
@export var damage: int = 10  # Damage the bullet deals

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# Move the bullet in its direction
	#position += direction * speed * delta
	pass


func _physics_process(delta: float) -> void:
	# Move the bullet in its direction
	position += direction * speed * delta


func set_direction(new_direction: Vector2) -> void:
	# Set the bullet's movement direction
	direction = new_direction.normalized()


func _on_timer_timeout() -> void:
	self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(1)
		queue_free()
