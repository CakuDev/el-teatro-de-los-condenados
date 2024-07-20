extends Node3D


const TUTORIAL_2 = preload("res://levels/tutorial/tutorial_2/tutorial_2.tscn")


func _on_button_on_pressed() -> void:
	get_tree().change_scene_to_packed(TUTORIAL_2)
