extends Control


const INTRO = preload("res://ui/intro/intro.tscn")


@onready var options_menu: Control = %OptionsMenu
@onready var exit_button: Button = %ExitButton
@onready var controls_menu: Control = $"Controls Menu"


func _ready() -> void:
	if OS.get_name() == "Web":
		exit_button.visible = false


func _on_start_button_button_up() -> void:
	get_tree().change_scene_to_packed(INTRO)


func _on_option_button_button_up() -> void:
	options_menu.visible = not options_menu.is_visible_in_tree()


func _on_exit_button_button_up() -> void:
	get_tree().quit()


func _on_controls_menu_button_up() -> void:
	controls_menu.visible = true
