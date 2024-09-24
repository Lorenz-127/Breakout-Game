extends RigidBody2D

@export var points = 10  # Default points for breaking a brick
@export var hit_points = 1  # Default hit points for the brick

var current_hit_points

func _ready():
	current_hit_points = hit_points

func hit():
	#print("Brick hit, current hit_points: ", current_hit_points)
	current_hit_points -= 1
	
	if current_hit_points <= 0:
		#print("Brick destroyed, adding points: ", points)
		GameMenu.add_points(points)
		destroy()
	else:
		show_damage()

func destroy():
	$BrickSprite2D.visible = false
	$BrickCollisionShape2D.disabled = true
	
	await get_tree().create_timer(1).timeout
	queue_free()

func show_damage():
	# Change the appearance of the brick to show it's been damaged
	$BrickSprite2D.modulate = Color(1, 1, 1, float(current_hit_points) / hit_points)
