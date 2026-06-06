extends Node2D 
# memo: create AnimatedSprite2D later for spritesheets! (only used sprite2D now) 
@export var speed := 140.0 

func _process(delta: float) -> void:
	position.y -= speed * delta
	
	#auto destruction: y-axis: 
	# moving down 
	#if position.y > get_viewport_rect().size.y + 200 
	#moving up: 
	if position.y < -200:
		queue_free() # destroys itself 
		
	
	
