class_name Model
extends Node3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func play_animation():
	if !animation_player.is_playing():
		animation_player.play("Cube|CubeAction")
		
		
func stop_animation():
	if animation_player.is_playing():
		animation_player.stop()
