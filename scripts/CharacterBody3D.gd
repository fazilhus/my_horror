extends CharacterBody3D


@export var SPEED = 4.0
@export var SPRINT_MUL = 1.25
@export var JUMP_VELOCITY = 3.5
@export var MOUSE_SENS = 0.001

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck_pivot := $Pivot
@onready var camera := $Pivot/Camera3D

var camera_anglev := 0

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left_strafe", "right_strafe", "forward", "backward")
	var direction = (neck_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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


func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck_pivot.rotate_y(-event.relative.x * MOUSE_SENS)
			camera.rotate_x(-event.relative.y * MOUSE_SENS)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))
