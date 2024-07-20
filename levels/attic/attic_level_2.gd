extends Node3D


const VICTORY_SCREEN = preload("res://menus/victory_screen/victory_screen.tscn")


func _on_button_on_pressed() -> void:
	get_tree().change_scene_to_packed(VICTORY_SCREEN)
