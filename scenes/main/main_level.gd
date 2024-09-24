extends Node2D

# Block scene used to instantiate

@onready var brick_object = preload("res://scenes/bricks/brick.tscn")
@onready var ball = preload("res://scenes/balls/ball.tscn")
@onready var game_over_scene = preload("res://scenes/menus/game_over.tscn")


var columns = 32 # Number of columns of blocks
var rows = 7 # Number of rows of blocks
var margin = 50 # Distance from edge of screen

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_level()
	GameMenu.connect("game_over", Callable(self, "end_game"))

func end_game(final_score: int):
	var game_over_instance = game_over_scene.instantiate()
	get_tree().root.add_child(game_over_instance)
	game_over_instance.set_score(final_score)
	game_over_instance.set_level(GameMenu.level)
	queue_free()  # Remove the current level

func setup_level():
	# Get colours for the briks and shuffle for variety
	var colors = get_neon_colors()
	colors.shuffle()
	GameMenu.set_level(GameMenu.level)
	GameMenu.show_content(true)
	
	# Place briks in a grid on screen
	for r in rows:
		for c in columns:
			# Generate random int number
			var random_number = randi_range(0, 2)
			if random_number > 0:
				# If random_number matched, place new_brik			
				var new_brick = brick_object.instantiate()
				add_child(new_brick)
				# Set brick size to 32*32
				new_brick.get_node("BrickSprite2D").scale = Vector2(0.5, 0.5)
				# Set placed brik to brick size + 2px for padding between briks
				new_brick.position = Vector2(margin + (34 * c), margin + (34 * r))
				
				#give block sprite some color
				var sprite = new_brick.get_node("BrickSprite2D")
				if r >= 9:
					sprite.modulate =  colors[0]
				if r < 9:
					sprite.modulate =  colors[1]
				if r < 6:
					sprite.modulate =  colors[2]
				if r < 3:
					sprite.modulate =  colors[3]

func get_neon_colors():
	var neon_colors = [
		Color(1.0, 0.0, 0.2, 1), # neon_red
		Color(0.35, 1.0, 0.34, 1), # neon_green
		Color(0.09, 0.91, 1.0, 1), # neon_blue
		Color(1.0, 0.97, 0.0, 1) # neon_yellow
	]
	
	return neon_colors
