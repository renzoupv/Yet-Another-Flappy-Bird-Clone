extends CanvasLayer

func update_score(value):
	$stats/ScoreLabel.text = str(value) + "m"

func _on_reset_pressed():
	get_parent().new_game()

func new_game():
	$display.show()
	$reset.hide()
func start_game():
	$display.hide()
func reset_game():
	$reset.show()
