class_name ControllableCharacter
extends CharacterBody3D

@export var can_move := false


const SPEED = 5.0
const JUMP_VELOCITY = 6.0
const LIFT_FORCE = 10.0


@onready var model: Model = $"Model"
@onready var controllable_character_controller: ControllableCharacterController = %ControllableCharacterController


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_lifting: bool = false
var character_to_lift: ControllableCharacter = null
var dashed := false
var dash_multiplier := 2.0
var current_movement_multiplier := 1.0
var i = 0
var group_characters: Array[ControllableCharacter] = []
var is_grouping := false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		dashed = false
		current_movement_multiplier = 1.0
		
	if !can_move:
		idle()
		move_and_slide()
		return

	if lift_condition():
		lift()
		
	if group_condition():
		group()
	elif ungroup_condition():
		ungroup()

	if jump_condition():
		jump(JUMP_VELOCITY)

	if movement_condition():
		var direction := get_input_direction()
		if direction:
			move(direction)
			rotate_model()
			
			if not is_on_floor() and Input.is_action_just_pressed("ui_accept"):
				current_movement_multiplier = dash_multiplier
				move(direction)
				dashed = true
				i = 0.0
		else:
			idle()
			
		if not is_on_floor() and dashed:
			current_movement_multiplier = lerp(2.0, 1.0, i)
			i += delta

	move_and_slide()
	

func movement_condition() -> bool:
	return !is_lifting	

	
func jump_condition() -> bool:
	return Input.is_action_just_pressed("ui_accept") and is_on_floor() and !is_lifting
	
	
func jump(jump_force: float) -> void:
	velocity.y = jump_force
	
	
func idle() -> void:
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.z = move_toward(velocity.z, 0, SPEED)
	

func get_input_direction() -> Vector3: 
	var input_dir := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
func move(direction: Vector3) -> void:
	velocity.x = direction.x * SPEED * current_movement_multiplier
	velocity.z = direction.z * SPEED * current_movement_multiplier
	
	
func rotate_model() -> void:
	var rotation_dir := Input.get_vector("movement_up", "movement_down", "movement_left", "movement_right")
	var model_rotation := Vector3(0, rotation_dir.angle(), 0)
	model.set_rotation(model_rotation)
	#model.play_animation()


func lift_condition() -> bool:
	return is_on_floor() and !is_lifting and Input.is_action_just_pressed("action") and character_to_lift != null


func lift() -> void:
	character_to_lift.jump(LIFT_FORCE)
	is_lifting = true
	await get_tree().create_timer(1.0, true).timeout
	print("Activating lift")
	is_lifting = false
	
	
func group_condition():
	return (
			controllable_character_controller.characters.size() == group_characters.size() 
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
	var characters := controllable_character_controller.characters
	var active_character := characters[controllable_character_controller.active_character]
	for character in characters:
		if character != active_character:
			character.can_move = false
	
	is_grouping = false


func _on_action_area_body_entered(body: Node3D) -> void:
	if body is ControllableCharacter:
		character_to_lift = body
	

func _on_action_area_body_exited(body: Node3D) -> void:
	if body is ControllableCharacter:
		character_to_lift = null


func _on_group_area_body_entered(body: Node3D) -> void:
	if body is ControllableCharacter:
		group_characters.append(body as ControllableCharacter)


func _on_group_area_body_exited(body: Node3D) -> void:
	if body is ControllableCharacter:
		group_characters.erase(body as ControllableCharacter)
		if is_grouping:
			ungroup()
