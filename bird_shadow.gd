extends Node2D 
# memo: create AnimatedSprite2D later for spritesheets! (only used sprite2D now) 

signal danger_started 
signal danger_ended 
@export var speed := 140.0 

func _process(delta: float) -> void:
	position.y -= speed * delta
	
	#auto destruction: y-axis: 
	# moving down 
	#if position.y > get_viewport_rect().size.y + 200 
	#moving up: 
	if position.y < -200:
		danger_ended.emit() 
		queue_free() # destroys itself 
		
	
func _ready() -> void:
	print("Bird ready")
	danger_started.emit()
