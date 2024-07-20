extends Control

@onready var f_3: TextureRect = $F3
@onready var f_1: TextureRect = $F1
@onready var f_2: TextureRect = $F2


func _ready() -> void:
	await get_tree().create_timer(4).timeout
	f_1.visible = false
	await get_tree().create_timer(4).timeout
	f_2.visible = false
	await get_tree().create_timer(4).timeout
	f_3.visible = false


func _on_back_menu_button_button_up() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn")
