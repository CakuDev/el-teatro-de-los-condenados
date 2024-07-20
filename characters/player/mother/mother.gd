class_name Mother
extends CharacterBody3D


const JUMP_SFX = preload("res://characters/player/sounds/jump_sfx.wav")
const DASH_SFX = preload("res://characters/player/sounds/dash_sfx.wav")


@export var can_move := false
@export var speed := 5.0
@export var jump_velocity := 6.0


@onready var model: Model = %Madre
@onready var controllable_character_controller: ControllableCharacterController = $"../ControllableCharacterController"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var object_to_press: RedButton = null
var is_being_lifted := false
var dashed := false
var dash_multiplier := 2.0
var current_movement_multiplier := 1.0
var i = 0
var group_characters: Array[Node3D] = []
var is_grouping := false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if !can_move:
		idle()
		move_and_slide()
		return
		
	if Input.is_action_just_pressed("action") and object_to_press != null:
		object_to_press.press()
		object_to_press = null
		
	#if group_condition():
	#	group()
	#elif ungroup_condition():
	#	ungroup()

	if jump_condition():
		jump(jump_velocity)

	if movement_condition():
		var direction := get_input_direction()
		if direction:
			move(direction)
			rotate_model()
			
			if not is_on_floor() and !is_grouping and Input.is_action_just_pressed("ui_accept") and !dashed:
				current_movement_multiplier = dash_multiplier
				move(direction)
				dashed = true
				i = 0.0
				audio_stream_player.stream = DASH_SFX
				audio_stream_player.play()
		else:
			idle()
			
		if not is_on_floor() and dashed:
			current_movement_multiplier = lerp(2.0, 1.0, i)
			i += delta
		
		if is_on_floor() and dashed:
			dashed = false
			current_movement_multiplier = 1
	move_and_slide()


func jump_condition() -> bool:
	return Input.is_action_just_pressed("ui_accept") and is_on_floor() and !is_being_lifted
	
	
func jump(jump_force: float) -> void:
	velocity.y = jump_force
	audio_stream_player.stream = JUMP_SFX
	audio_stream_player.play()
	model.play_animation("Jump")
	
	
func idle() -> void:
	velocity.x = move_toward(velocity.x, 0, speed)
	velocity.z = move_toward(velocity.z, 0, speed)
	if is_on_floor():
		model.play_animation("Iddle")
	

func get_input_direction() -> Vector3: 
	var input_dir := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
func movement_condition():
	return !is_being_lifted

	
func move(direction: Vector3) -> void:
	velocity.x = direction.x * speed * current_movement_multiplier
	velocity.z = direction.z * speed * current_movement_multiplier
	if is_on_floor() and !jump_condition():
		model.play_animation("Walk")
	
	
func rotate_model() -> void:
	var rotation_dir := Input.get_vector("movement_up", "movement_down", "movement_left", "movement_right")
	var model_rotation := Vector3(0, rotation_dir.angle(), 0) + Vector3(0, PI, 0)
	model.set_rotation(model_rotation)


func group_condition():
	return (
			controllable_character_controller.characters.size() - 1 == group_characters.size() 
			and can_move 
			and Input.is_action_just_pressed("action")
			and !is_grouping
	)
	
	
func group():
	for character in controllable_character_controller.characters:
		character.can_move = true
	
	is_grouping = true
		
		
func ungroup_condition():
	return (
			Input.is_action_just_pressed("action")
			and is_grouping
	)
		

func ungroup():
	var characters = controllable_character_controller.characters
	var active_character = characters[controllable_character_controller.active_character]
	for character in characters:
		if character != active_character:
			character.can_move = false
	
	is_grouping = false


func _on_action_area_body_entered(body: Node3D) -> void:
	if body is RedButton:
		object_to_press = body as RedButton


func _on_action_area_body_exited(body: Node3D) -> void:
	if body is RedButton:
		object_to_press = null


func _on_group_area_body_entered(body: Node3D) -> void:
	if body is Child or body is Father:
		group_characters.append(body)


func _on_group_area_body_exited(body: Node3D) -> void:
	if body is Child or body is Father:
		group_characters.erase(body)
		if is_grouping:
			ungroup()
