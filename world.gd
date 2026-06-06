extends Node2D 

@export var bird_scene : PackedScene 

func spawn_bird(): 
	print("spawning bird...")
	var bird = bird_scene.instantiate()
	bird.position = Vector2(300, get_viewport_rect().size.y + 200 )
	add_child(bird)
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_B):
		spawn_bird()
		#print("Bird spawned")
