extends Area2D

@onready var sprite = $Sprite2D

var target_scale = Vector2.ONE 

func react(): 
	target_scale = Vector2(1.2, 1.2)
	
func _process(delta): 
	sprite.scale = sprite.scale.lerp(target_scale, 5 * delta)
	
	target_scale = target_scale.lerp(Vector2.ONE, 2 * delta)
	
