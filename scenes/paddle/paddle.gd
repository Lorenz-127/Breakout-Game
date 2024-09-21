extends CharacterBody2D

@export var speed = 400.0  # Adjust this to control paddle speed
@export var paddle_width = 100.0  # Width of the paddle

var screen_size: Vector2

func _ready():
	# Get the size of the game window
	screen_size = get_viewport_rect().size
	
	# Set initial position of the paddle
	position.y = screen_size.y - 150  # 150 pixels from the bottom
	position.x = screen_size.x / 2  # Center horizontally

func _physics_process(delta):
	# Get input for left and right movement
	var direction = Input.get_axis("left", "right")
	
	# Calculate velocity
	velocity.x = direction * speed
	
	# Move the paddle
	move_and_slide()
	
	# Clamp the paddle's position to stay within the screen bounds
	position.x = clamp(position.x, paddle_width / 2, screen_size.x - paddle_width / 2)
