class_name ControllableCharacter
extends CharacterBody3D

@export var movement_blocked := false


const SPEED = 5.0
const JUMP_VELOCITY = 6.0
const LIFT_FORCE = 10.0


@onready var model: Model = $"Model"


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_lifting: bool = false
var character_to_lift: ControllableCharacter = null

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if !movement_blocked:
		idle()
		move_and_slide()
		return

	if lift_condition():
		lift()

	if jump_condition():
		jump(JUMP_VELOCITY)

	var direction := get_input_direction()
	if direction:
		move(direction)
		rotate_model()
	else:
		idle()

	move_and_slide()
	
	
func jump_condition() -> bool:
	return Input.is_action_just_pressed("ui_accept") and is_on_floor()
	
	
func jump(jump_force: float) -> void:
	velocity.y = jump_force
	
	
func idle():
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.z = move_toward(velocity.z, 0, SPEED)
	

func get_input_direction() -> Vector3: 
	var input_dir := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
func move(direction: Vector3) -> void:
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	
func rotate_model() -> void:
	var rotation_dir := Input.get_vector("movement_up", "movement_down", "movement_left", "movement_right")
	var model_rotation := Vector3(0, rotation_dir.angle(), 0)
	model.set_rotation(model_rotation)
	#model.play_animation()


func lift_condition() -> bool:
	return is_on_floor() and !is_lifting and Input.is_action_just_pressed("action")


func lift():
	character_to_lift.jump(LIFT_FORCE)


func _on_action_area_body_entered(body: Node3D) -> void:
	if body is ControllableCharacter:
		print("ENTER: " + body.name)
		character_to_lift = body
	

func _on_action_area_body_exited(body: Node3D) -> void:
	if body is ControllableCharacter:
		print("EXIT: " + body.name)
		character_to_lift = null
