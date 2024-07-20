extends Node3D


const CHEST_LEVEL = preload("res://levels/chest/chest_level.tscn")

func _on_button_on_pressed() -> void:
	get_tree().change_scene_to_packed(CHEST_LEVEL)
