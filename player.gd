extends Node2D

## player.tscn contains an AnimatedSprite2D called Butterfly 

# TODO: update like: sprite.stop() instead of stop() 
@onready var sprite := $Butterfly
@export var acceleration := 400.0
@export var max_speed := 250.0
#@export var panic_max_speed := 500.0
@export var friction := 250.0
@export var rotation_speed := 5.0

var in_danger := false 
var near_flower := false 
var nearby_flower = null
var velocity := Vector2.ZERO
var is_hiding := false 

func _process(delta):
	# delta = time since last frame 
	# might be ~ 0.016 at 60 FPS
	# without delta it would move:
	# faster on fast computers,
	# slower on slow computers.
	# Disaster.
	var screen_size = get_viewport_rect().size 
	var margin = 24
	var input_direction = Vector2.ZERO
	# (x, y) : (0,0) stay 
#	W = (0, -1)
#	S = (0, 1)
#	A = (-1, 0)
#	D = (1, 0)
	
	# hiding mechanic 
	if Input.is_key_pressed(KEY_R) && near_flower: 
		is_hiding = true 
	else: 
		is_hiding = false
		
	if is_hiding: 
		sprite.modulate.a = 0.5
		sprite.stop()
		# sprite.modulate.a => opacity 
	else: 
		sprite.modulate.a = 1.0 
		if not sprite.is_playing():
			sprite.play("fly")
	
	# direction with WSAD KEYS: 
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

	if Input.is_key_pressed(KEY_SHIFT) || in_danger:
		current_acceleration *= 1.8 
		current_max_speed *= 2.5 
	
		if sprite.animation != "panic_flutter":
			sprite.play("panic_flutter")
	else:
		if sprite.animation != "fly":
			sprite.play("fly")
		
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
	
	# clamp inside screen_size 
	position.x = clamp(position.x, margin, screen_size.x - margin)
	position.y = clamp(position.y, margin, screen_size.y - margin)

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
	# print("touching flower")
	if area.has_method("react"):
		area.react()
		
	if area.is_in_group("flowers"):
		near_flower = true 
		print("entered flower") 

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("flowers"):
		near_flower = false 
		print("left flower")
