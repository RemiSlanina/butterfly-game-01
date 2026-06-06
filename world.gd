extends Node2D 

@export var bird_scene : PackedScene 
@onready var butterfly = $Butterfly

func spawn_bird(): 
	print("spawning bird...")
	var bird = bird_scene.instantiate()
	bird.position = Vector2(300, get_viewport_rect().size.y + 200 )
	bird.danger_started.connect(_on_danger_started) 
	bird.danger_ended.connect(_on_danger_ended)
	add_child(bird)
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_B):
		spawn_bird()
		#print("DANGER")

func _on_danger_started(): 
	print("Danger!") 
	butterfly.in_danger = true 
	
	
func _on_danger_ended(): 
	print("Save!") 
	butterfly.in_danger = false 
