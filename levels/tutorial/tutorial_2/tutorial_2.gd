extends Node3D


const TUTORIAL_3 = preload("res://levels/tutorial/tutorial_3/tutorial_3.tscn")



func _on_button_on_pressed() -> void:
	get_tree().change_scene_to_packed(TUTORIAL_3)
