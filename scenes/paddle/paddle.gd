extends CharacterBody2D

@export var speed = 400.0
@export var paddle_width = 100.0
var screen_size: Vector2
var ball_attached = true

@onready var ball = get_tree().get_nodes_in_group("ball")[0]
@onready var collision_shape = $PaddleCollisionShape2D

func _ready():
	add_to_group("paddle")  # Ensure the paddle is in the "paddle" group
	screen_size = get_viewport_rect().size
	position.y = screen_size.y - 150
	position.x = screen_size.x / 2
	reset_ball_position()
	GameMenu.connect("game_over", Callable(self, "_on_game_over"))

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	velocity = Vector2(direction * speed, 0)  # Only set horizontal velocity
	move_and_slide()
	position.x = clamp(position.x, paddle_width / 2, screen_size.x - paddle_width / 2)
	position.y = screen_size.y - 150  # Force Y position to remain constant
	
	if ball_attached:
		update_ball_position()

func _unhandled_input(event):
	if event.is_action_pressed("launch_ball") and ball_attached:
		launch_ball()

func launch_ball():
	if ball_attached:
		ball_attached = false
		ball.launch()

func reset_ball_position():
	ball_attached = true
	update_ball_position()
	ball.is_active = false  # Ensure the ball is not moving

func update_ball_position():
	var paddle_height = collision_shape.shape.size.y * scale.y
	ball.position = position + Vector2(0, -paddle_height / 2 - ball.get_node("BallCollisionShape2D").shape.radius)

func _on_ball_lost():
	# This function should be called when the ball enters the death zone
	if GameMenu.lives > 0:
		reset_ball_position()
	# GameMenu will handle decreasing lives and checking for game over

func _on_game_over(_final_score):
	# Disable paddle movement when game is over
	set_physics_process(false)
	set_process_input(false)
