extends Area2D

signal hit

enum PipeOrientation {
	NORMAL,
	HORIZONTAL,
	DIAGONAL_LEFT,
	DIAGONAL_RIGHT,
	RANDOM
}

@export var orientation : PipeOrientation = PipeOrientation.NORMAL

func _ready():
	match orientation:
		PipeOrientation.NORMAL:
			rotation_degrees = 0
		PipeOrientation.HORIZONTAL:
			rotation_degrees = 90
		PipeOrientation.DIAGONAL_LEFT:
			rotation_degrees = -30
		PipeOrientation.DIAGONAL_RIGHT:
			rotation_degrees = 30
		PipeOrientation.RANDOM:
			rotation_degrees = randf_range(0, 360)

func _on_body_entered(body):
	if body.is_in_group("player"):
		hit.emit()
