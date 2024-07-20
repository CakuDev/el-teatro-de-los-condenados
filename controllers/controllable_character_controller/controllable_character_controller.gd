class_name ControllableCharacterController
extends Node3D


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


@export var characters: Array[Node3D]


var active_character := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	characters[active_character].can_move = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_character_left"):
		characters[active_character].can_move = false
		
		if active_character == 0:
			active_character = characters.size() - 1
		else:
			active_character = active_character - 1
		
		characters[active_character].can_move = true
		
		audio_stream_player.play()
	if Input.is_action_just_pressed("change_character_right"):
		characters[active_character].can_move = false
		if active_character == characters.size() - 1:
			active_character = 0
		else:
			active_character = active_character + 1
		characters[active_character].can_move = true
		audio_stream_player.play()
