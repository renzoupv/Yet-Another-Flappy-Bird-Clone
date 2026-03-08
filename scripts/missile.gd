extends Area2D

signal hit

func _ready():
	$MissileLaunch.pitch_scale = randf_range(0.5, 3)
	$MissileLaunch.play()
	
func _on_body_entered(body):
	if body.name == "Bird":
		impact()
		hit.emit()
		$MissileExplosion.play()
		
func impact():
	$missile.hide()
	$explode.emitting = true
	$trail.emitting = false
