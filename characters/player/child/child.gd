class_name Child
extends CharacterBody3D


const JUMP_SFX: AudioStream = preload("res://characters/player/sounds/jump_sfx.wav")


@export var can_move := false
@export var speed := 5.0
@export var jump_velocity := 6.0
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


@onready var model: Model = %Hijo


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var object_to_press: RedButton = null
var is_being_lifted := false


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

	if jump_condition():
		jump(jump_velocity)

	if movement_condition():
		var direction := get_input_direction()
		if direction:
			move(direction)
			rotate_model()
		else:
			idle()

	move_and_slide()


func jump_condition() -> bool:
	return Input.is_action_just_pressed("ui_accept") and is_on_floor() and !is_being_lifted
	
	
func jump(jump_force: float) -> void:
	velocity.y = jump_force
	model.play_animation("Jump")
	audio_stream_player.stream = JUMP_SFX
	audio_stream_player.play()
	
	
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
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	if is_on_floor() and !jump_condition():
		model.play_animation("Walk")
	
	
func rotate_model() -> void:
	var rotation_dir := Input.get_vector("movement_up", "movement_down", "movement_left", "movement_right")
	var model_rotation := Vector3(0, rotation_dir.angle(), 0) + Vector3(0, PI, 0)
	model.set_rotation(model_rotation)


func _on_action_area_body_entered(body: Node3D) -> void:
	if body is RedButton:
		object_to_press = body as RedButton


func _on_action_area_body_exited(body: Node3D) -> void:
	if body is RedButton:
		object_to_press = null
