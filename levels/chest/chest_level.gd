extends Node3D


const ATTIC_LEVEL_1 = preload("res://levels/attic/attic_level_1.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Child:
		get_tree().change_scene_to_packed(ATTIC_LEVEL_1)
