class_name Model
extends Node3D


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func play_animation(anim: String) -> void:
	if !animation_player.is_playing() or !animation_player.current_animation == anim:
		#print("Calling anim " + anim + " in " + get_parent().name)
		animation_player.play(anim)
		
		
func stop_animation():
	if animation_player.is_playing():
		animation_player.stop()
