extends Control

@onready var play_button = $MarginContainer/VBoxContainer/ButtonContainer/PlayButton
@onready var options_button = $MarginContainer/VBoxContainer/ButtonContainer/OptionsButton
@onready var exit_button = $MarginContainer/VBoxContainer/ButtonContainer/ExitButton
@onready var title_label = $MarginContainer/VBoxContainer/Title

@onready var start_level = preload("res://scenes/main/main_level.tscn") as PackedScene

var tween: Tween

func _ready():
	GameMenu.show_content(false)
	handle_connecting_signals()
	setup_neon_effect()
	get_tree().root.size_changed.connect(on_window_resized)
	on_window_resized()


func setup_neon_effect():
	tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(title_label, "modulate", Color(1, 1, 1, 0.7), 1.0)
	tween.tween_property(title_label, "modulate", Color(1, 1, 1, 1.0), 1.0)

func on_play_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_options_pressed() -> void:
	# Implement options menu logic here
	pass

func on_exit_pressed() -> void:
	get_tree().quit()

func handle_connecting_signals() -> void:
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	exit_button.pressed.connect(on_exit_pressed)

func on_window_resized():
	var window_size = get_viewport_rect().size
	var scale_factor = min(window_size.x / 1920.0, window_size.y / 1080.0)
	
	title_label.add_theme_font_size_override("font_size", int(64 * scale_factor))
	
	var button_font_size = int(24 * scale_factor)
	var button_min_size = Vector2(200 * scale_factor, 50 * scale_factor)
	
	for button in [play_button, options_button, exit_button]:
		button.add_theme_font_size_override("font_size", button_font_size)
		button.custom_minimum_size = button_min_size

func _process(delta):
	var t = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(t * 2.0) + 1.0) / 2.0
	var color = Color(0, 1, 1, 0.5 + pulse * 0.5)
	
	for button in [play_button, options_button, exit_button]:
		button.add_theme_color_override("font_outline_color", color)
		
func _exit_tree():
	GameMenu.show_content(true)
