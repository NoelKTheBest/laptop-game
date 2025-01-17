extends Camera2D

@export var pan_speed: float = 500.0  # Speed of manual panning
@export var zoom_speed: float = 0.1  # Speed of zoom adjustment
@export var zoom_limits: Vector2 = Vector2(0.5, 2.0)  # Min and max zoom
@export var smoothness: float = 5.0  # Smoothness factor for interpolation
@export var edge_pan_margin: int = 50  # Edge panning margin
@export var edge_pan_speed: float = 300.0  # Edge panning speed
@export var level_bounds: Rect2 = Rect2(Vector2.ZERO, Vector2(2000, 2000))  # Level boundaries

var target_position: Vector2
var target_zoom: Vector2
var shake_intensity: float = 0.0

@onready var fade_rect: ColorRect = $"../ColorRect"

func _ready() -> void:
	# Initialize target position and zoom
	target_position = position
	target_zoom = zoom

func _input(event: InputEvent) -> void:
	# Handle dragging and zooming
	if event is InputEventMouseMotion and Input.is_action_pressed("ui_right_click"):
		target_position -= event.relative * zoom
	elif event is InputEventMouseMotion and event.relative.y != 0:
		# Adjust zoom based on scroll
		var new_zoom = target_zoom - event.relative.y * zoom_speed
		target_zoom = Vector2(
			clamp(new_zoom.x, zoom_limits.x, zoom_limits.y),
			clamp(new_zoom.y, zoom_limits.x, zoom_limits.y)
		)

func _process(delta: float) -> void:
	# Smoothly interpolate position and zoom
	position = position.lerp(target_position, delta * smoothness)
	zoom = zoom.lerp(target_zoom, delta * smoothness)

	# Edge panning
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_position = get_viewport().get_mouse_position()

	if mouse_position.x < edge_pan_margin:
		target_position.x -= edge_pan_speed * delta
	elif mouse_position.x > viewport_size.x - edge_pan_margin:
		target_position.x += edge_pan_speed * delta

	if mouse_position.y < edge_pan_margin:
		target_position.y -= edge_pan_speed * delta
	elif mouse_position.y > viewport_size.y - edge_pan_margin:
		target_position.y += edge_pan_speed * delta

	# Clamp position to level bounds
	position.x = clamp(position.x, level_bounds.position.x, level_bounds.position.x + level_bounds.size.x)
	position.y = clamp(position.y, level_bounds.position.y, level_bounds.position.y + level_bounds.size.y)

	# Add shake effect
	if shake_intensity > 0:
		position += Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		shake_intensity = max(shake_intensity - delta * 5.0, 0)

# Apply screen shake with a specific intensity
func apply_screen_shake(intensity: float) -> void:
	shake_intensity = intensity

# Fade to black
func fade_to_black(duration: float) -> void:
	fade_rect.visible = true
	fade_rect.modulate = Color(0, 0, 0, 0)
	fade_rect.modulate = fade_rect.modulate.lerp(Color(0, 0, 0, 1), duration)

# Fade to clear
func fade_to_clear(duration: float) -> void:
	fade_rect.modulate = fade_rect.modulate.lerp(Color(0, 0, 0, 0), duration)
