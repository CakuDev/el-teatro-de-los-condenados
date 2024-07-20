extends Node3D


const ATTIC_LEVEL_2 = preload("res://levels/attic/attic_level_2.tscn")

func _on_button_on_pressed() -> void:
	get_tree().change_scene_to_packed(ATTIC_LEVEL_2)
