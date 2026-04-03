extends Area2D

signal hit

func _ready():
	$MissileLaunch.pitch_scale = randf_range(0.5, 1.5)
	$MissileLaunch.play()

func _on_body_entered(body):
	if body.is_in_group("player"):
		$MissileExplosion.play()
		hit.emit()
		queue_free()
