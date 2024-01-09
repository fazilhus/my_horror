extends CharacterBody3D


const SPEED = 4.0
const SPRINT_MUL = 1.2
const JUMP_VELOCITY = 3.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left_strafe", "right_strafe", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var cspeed = SPEED
	if direction:
		if Input.is_action_pressed("sprint"):
			cspeed *= SPRINT_MUL
		velocity.x = direction.x * cspeed
		velocity.z = direction.z * cspeed
	else:
		velocity.x = move_toward(velocity.x, 0, cspeed)
		velocity.z = move_toward(velocity.z, 0, cspeed)

	move_and_slide()
