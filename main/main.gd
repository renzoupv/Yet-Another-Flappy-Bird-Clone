extends Node2D

@export var pipe_scene: PackedScene

var game_running: bool
var game_over: bool
var scroll: int
var score: int

const SCROLL_SPEED: int = 4
const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 200

var screen_size: Vector2i
var ground_height: int
var pipes: Array = []

func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0

	$ScoreLabel.text = "Score: " + str(score)
	$GameOver.hide()

	get_tree().call_group("pipes", "queue_free")
	pipes.clear()

	generate_pipes()
	$Bird.reset()

func _input(event):
	if game_over == false:
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_SPACE:
				if game_running == false:
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()
						check_top()

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$PipeTimer.start()

func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED

		# reset scroll
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll

		# move pipes left + bob up/down
		for pipe in pipes:
			if not is_instance_valid(pipe):
				continue

			pipe.position.x -= SCROLL_SPEED

			# ✅ beginner-friendly vertical movement
			pipe.move_time += delta
			pipe.position.y = pipe.base_y + sin(pipe.move_time * pipe.move_speed) * pipe.move_amp

func _on_pipe_timer_timeout() -> void:
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()

	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)

	# set up chaos movement variables on the pipe
	pipe.base_y = pipe.position.y
	pipe.move_amp = randf_range(15.0, 40.0)   # how far it moves up/down
	pipe.move_speed = randf_range(1.5, 10.0)   # how fast it moves
	pipe.move_time = randf_range(0.0, 10.0)   # random start so pipes don’t sync

	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)

	add_child(pipe)
	pipes.append(pipe)

func scored():
	score += 1
	$ScoreLabel.text = "Score: " + str(score)

func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$Bird.flying = false
	game_running = false
	game_over = true

func bird_hit():
	$Bird.falling = true
	stop_game()

func _on_ground_hit() -> void:
	$Bird.falling = false
	stop_game()

func _on_game_over_restart() -> void:
	new_game()
