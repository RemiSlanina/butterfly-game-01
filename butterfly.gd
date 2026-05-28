extends AnimatedSprite2D

@export var acceleration := 400.0
@export var max_speed := 250.0
#@export var panic_max_speed := 500.0
@export var friction := 250.0
@export var rotation_speed := 5.0

var nearby_flower = null
var velocity := Vector2.ZERO

func _process(delta):
	# delta = time since last frame 
	# might be ~ 0.016 at 60 FPS
	# without delta it would move:
#	faster on fast computers,
#	slower on slow computers.
#	Disaster.
	var input_direction = Vector2.ZERO
	# (x, y) : (0,0) stay 
#	W = (0, -1)
#	S = (0, 1)
#	A = (-1, 0)
#	D = (1, 0)

	if Input.is_key_pressed(KEY_W):
		input_direction.y -= 1

	if Input.is_key_pressed(KEY_S):
		input_direction.y += 1

	if Input.is_key_pressed(KEY_A):
		input_direction.x -= 1

	if Input.is_key_pressed(KEY_D):
		input_direction.x += 1

	input_direction = input_direction.normalized()

	# panic flutter 
	var current_acceleration = acceleration
	var current_max_speed = max_speed

	if Input.is_key_pressed(KEY_SHIFT):
		current_acceleration *= 1.8 
		current_max_speed *= 2.5 
	
		if animation != "panic_flutter":
			play("panic_flutter")
	else:
		if animation != "fly":
			play("fly")
		
	# accelerate
	if input_direction != Vector2.ZERO:
		velocity += input_direction * current_acceleration * delta
	else:
		# glide / slow down
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	# clamp max speed
#	if animation != "panic_flutter":
#		velocity = velocity.limit_length(max_speed)
#	else:
#		velocity = velocity.limit_length(panic_max_speed)
	velocity = velocity.limit_length(current_max_speed)

	# move
	position += velocity * delta

	# rotate toward movement
	# velocity.angle() : 0 radians = pointing right angle 0 points along positive X axis 
	# Regular interpolation ("lerp") means: 
	# move gradually from A to B
	if velocity.length() > 5:
		rotation = lerp_angle(
			rotation,
			velocity.angle() + deg_to_rad(90),
			rotation_speed * delta * 1.7
		)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("touching flower")
	if area.has_method("react"):
		area.react()
