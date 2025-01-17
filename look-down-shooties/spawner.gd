extends Node2D


@export var enemy_scene: PackedScene  # Assign Enemy.tscn here
@export var spawn_interval: float = 2.0
@export var spawn_area: Rect2  # Define where enemies can spawn

func _ready() -> void:
	# Start spawning enemies
	spawn_enemy()
	await get_tree().create_timer(spawn_interval).timeout
	spawn_enemy()
	await get_tree().create_timer(spawn_interval).timeout
	spawn_enemy()

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	var spawn_position = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)
	enemy.position = spawn_position
	get_tree().root.add_child.call_deferred(enemy)
