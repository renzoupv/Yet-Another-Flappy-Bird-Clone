extends Node2D

func _ready():
	$MissileWarning.play()
	$AnimatedSprite2D.play()
	await get_tree().create_timer(1.0).timeout
	
	if not is_inside_tree():
		return
	
	queue_free()
