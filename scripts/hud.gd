extends CanvasLayer

#updates score
func update_score(value):
	$stats/ScoreLabel.text = "Distance             " + str(value) + "m"

#calls newgame() in parent node
func _on_reset_pressed():
	get_parent().new_game()

#button and label display functions
func new_game():
	$display.show()
	$reset.hide()

func start_game():
	$display.hide()

func reset_game():
	$reset.show()
