extends Node2D 

@export var bird_scene : PackedScene 
@onready var player = $Player
@onready var timer = $BirdTimer 

func _ready(): 
	timer.start(randf_range(3.0, 8.0)) 
	
func _on_bird_timer_timeout(): 
	spawn_bird() 
	print("DANGER")
	timer.start(randf_range(6.0, 12.0))

func spawn_bird(): 
	print("spawning bird...")
	var bird = bird_scene.instantiate()
	bird.position = get_bird_position()
	bird.danger_started.connect(_on_danger_started) 
	bird.danger_ended.connect(_on_danger_ended)
	add_child(bird)
	
func _process(delta: float) -> void:
	# using Porject/Settings/Input Map: Key B
	if Input.is_action_just_pressed("spawn_bird"): 
		spawn_bird()
		#print("DANGER")

func _on_danger_started(): 
	print("Danger!") 
	player.in_danger = true 
	
	
func _on_danger_ended(): 
	print("Save!") 
	player.in_danger = false 
	
# ********* helper functions  *********  

func get_bird_position() -> Vector2: 
	var width = get_viewport_rect().size.x 
	return Vector2(
		randf_range(100, width - 100), 
		get_viewport_rect().size.y + 200
	)
