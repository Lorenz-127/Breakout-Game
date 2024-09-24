extends Node

signal game_over(final_score)

var score: int = 0
var level: int = 1
var lives: int = 3
var score_label: Label
var lives_label: Label
var level_label: Label
var canvas_layer: CanvasLayer

func _ready():
	#print("GameMenu instance initialized")
	canvas_layer = get_node("CanvasLayer")
	score_label = canvas_layer.get_node_or_null("ScoreLabel")
	lives_label = canvas_layer.get_node_or_null("LivesLabel")
	level_label = canvas_layer.get_node_or_null("LevelsLabel")
	update_ui()

func show_content(show: bool):
	if canvas_layer:
		canvas_layer.visible = show

func add_points(points):
	score += points
	update_ui()

func decrease_lives():
	lives -= 1
	update_ui()
	if lives <= 0:
		emit_signal("game_over", score)

func update_ui():
	if score_label:
		score_label.text = "Score: " + str(score).pad_zeros(4)
	if lives_label:
		lives_label.text = "Lives: " + str(lives)
	if level_label:
		level_label.text = "Level: " + str(level)

func set_level(new_level):
	level = new_level
	update_ui()

func set_lives(new_lives):
	lives = new_lives
	update_ui()

func reset():
	score = 0
	level = 1
	lives = 3
	update_ui()
