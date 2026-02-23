extends Area2D

signal hit
signal scored

var base_y: float = 0.0
var move_amp: float = 0.0
var move_speed: float = 0.0
var move_time: float = 0.0

func _ready() -> void:
	add_to_group("pipes")

func _on_body_entered(body: Node2D) -> void:
	hit.emit()


func _on_score_area_body_entered(body: Node2D) -> void:
	scored.emit()
