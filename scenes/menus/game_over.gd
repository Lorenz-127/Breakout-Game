extends Control

@onready var restart_button = $MarginContainer/VBoxContainer/ButtonContainer/RestartButton
@onready var main_menu_button = $MarginContainer/VBoxContainer/ButtonContainer/MainMenuButton
@onready var title_label = $MarginContainer/VBoxContainer/Title
@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var level_label = $MarginContainer/VBoxContainer/LevelLabel


var tween: Tween

func _ready():
	GameMenu.show_content(false)
	handle_connecting_signals()
	setup_neon_effect()
	get_tree().root.size_changed.connect(on_window_resized)
	on_window_resized()
	
	# Test set_score
	set_score(GameMenu.score)
	set_level(GameMenu.level)

func set_score(final_score):
	if not score_label:
		score_label = $MarginContainer/VBoxContainer/ScoreLabel
	
	if score_label:
		score_label.text = "Final Score: " + str(final_score)
	else:
		push_error("Score label not found in game over screen.")
		
func set_level(final_level):
	if not level_label:
		level_label = $MarginContainer/VBoxContainer/LevelLabel
	
	if level_label:
		level_label.text = "Final Level: " + str(final_level)
	else:
		push_error("Level label not found in game over screen.")

func on_restart_pressed():
	GameMenu.reset()
	# Remove this scene from the tree before changing to the new scene
	queue_free()
	get_tree().change_scene_to_file("res://scenes/main/main_level.tscn")
	
func on_main_menu_pressed():
	GameMenu.reset()
	# Remove this scene from the tree before changing to the new scene
	queue_free()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func handle_connecting_signals():
	restart_button.pressed.connect(on_restart_pressed)
	main_menu_button.pressed.connect(on_main_menu_pressed)

func setup_neon_effect():
	tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(title_label, "modulate", Color(1, 1, 1, 0.7), 1.0)
	tween.tween_property(title_label, "modulate", Color(1, 1, 1, 1.0), 1.0)

func on_window_resized():
	var window_size = get_viewport_rect().size
	var scale_factor = min(window_size.x / 1920.0, window_size.y / 1080.0)
	
	title_label.add_theme_font_size_override("font_size", int(64 * scale_factor))
	#score_label.add_theme_font_size_override("font_size", int(32 * scale_factor))
	
	var button_font_size = int(24 * scale_factor)
	var button_min_size = Vector2(200 * scale_factor, 50 * scale_factor)
	
	for button in [restart_button, main_menu_button]:
		button.add_theme_font_size_override("font_size", button_font_size)
		button.custom_minimum_size = button_min_size

func _process(delta):
	var t = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(t * 2.0) + 1.0) / 2.0
	var color = Color(0, 1, 1, 0.5 + pulse * 0.5)
	
	for button in [restart_button, main_menu_button]:
		button.add_theme_color_override("font_outline_color", color)
