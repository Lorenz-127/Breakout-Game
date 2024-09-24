extends CharacterBody2D

@export var speed = 200.0
var is_active = false

@onready var paddle = get_tree().get_nodes_in_group("paddle")[0]

func _ready():
	if paddle == null:
		push_error("Paddle not found. Make sure it's in the 'paddle' group.")

func _physics_process(delta: float) -> void:
	if is_active:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			
			if velocity.y > 0 and velocity.y < 100:
				velocity.y = -200
			if velocity.x == 0:
				velocity.x = -200
			
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit()

func launch():
	is_active = true
	velocity = Vector2(randf_range(-0.5, 0.5), -1).normalized() * speed

func _on_death_zone_body_entered(_body):
	is_active = false
	GameMenu.decrease_lives()
	if paddle:
		paddle._on_ball_lost()  # Notify the paddle that the ball was lost
	else:
		push_error("Paddle not found when ball was lost.")
