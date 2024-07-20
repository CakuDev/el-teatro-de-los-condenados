extends Control


const TUTORIAL_1 = preload("res://levels/tutorial/tutorial_1/tutorial_1.tscn")


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_packed(TUTORIAL_1)
