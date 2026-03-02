extends Node2D

var game_running := false
var game_over := false

var scroll := 0.0
var base_scroll_speed := 200.0
var scroll_speed := 200.0

var distance_score := 0.0
var score := 0

var difficulty_timer := 0.0
var missile_difficulty_timer := 0.0

var screen_size : Vector2i

@export var warning_scene : PackedScene
@export var missile_scene : PackedScene
@export var pipe_scene : PackedScene

var pipes : Array = []
var missiles : Array = []

func _ready() -> void:
	screen_size = get_window().size
	new_game()

func new_game() -> void:
	game_running = false
	game_over = false
	scroll = 0
	distance_score = 0
	score = 0
	difficulty_timer = 0
	missile_difficulty_timer = 0
	scroll_speed = base_scroll_speed
	
	for p in pipes:
		if is_instance_valid(p):
			p.queue_free()
	pipes.clear()

	for m in missiles:
		if is_instance_valid(m):
			m.queue_free()
	missiles.clear()

	$bird.reset()
	#$HUD.update_score(0)

func _input(event):
	if game_over:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not game_running:
				start_game()
			else:
				$bird.flap()

func start_game():
	game_running = true
	$bird.start()
	$PipeTimer.start()
	$MissileTimer.start()

func _process(delta):
	if not game_running:
		return

	# Smooth difficulty scaling
	difficulty_timer += delta
	
	if difficulty_timer > 5:
		difficulty_timer = 0
	
	$PipeTimer.wait_time = min(1.5, $PipeTimer.wait_time * 0.1)
	$MissileTimer.wait_time = min(2.0, $MissileTimer.wait_time * 0.1)
	
	scroll_speed = base_scroll_speed + difficulty_timer * 10.0

	# Scroll world
	scroll += scroll_speed * delta
	if scroll >= screen_size.x:
		scroll = 0

	$ground.position.x = -scroll

	# Move pipes
	for pipe in pipes:
		if is_instance_valid(pipe):
			pipe.position.x -= scroll_speed * delta

	# Move missiles
	for missile in missiles:
		if is_instance_valid(missile):
			missile.position.x -= (scroll_speed + 150) * delta

	# Cleanup offscreen objects
	for i in range(pipes.size() - 1, -1, -1):
		if is_instance_valid(pipes[i]) and pipes[i].position.x < -200:
			pipes[i].queue_free()
			pipes.remove_at(i)

	for i in range(missiles.size() - 1, -1, -1):
		if is_instance_valid(missiles[i]) and missiles[i].position.x < -200:
			missiles[i].queue_free()
			missiles.remove_at(i)

	# Distance score
	distance_score += scroll_speed * delta
	score = int(distance_score / 10.0)
	#$HUD.update_score(score)

func _on_pipe_timer_timeout():
	generate_pipe()

func generate_pipe():
	var pipe = pipe_scene.instantiate()
	pipe.position = Vector2(screen_size.x + 100, pipe_position())
	pipe.orientation = randi_range(0, 4)
	pipe.hit.connect(bird_hit)
	add_child(pipe)
	pipes.append(pipe)

func pipe_position() -> int:
	var top = 140
	var middle = (screen_size.y / 2) + 10
	var bottom = screen_size.y - 100

	var lanes = [top, middle, bottom]
	return lanes[randi_range(0, lanes.size() - 1)]

func _on_missile_timer_timeout():
	generate_missile()

func generate_missile():
	var spawn_pos = Vector2(
		int(screen_size.x - 6),
		clamp($bird.position.y, 100, screen_size.y - 100)
	)

	var warning = warning_scene.instantiate()
	warning.position = spawn_pos
	add_child(warning)

	await get_tree().create_timer(randf_range(0.6, 1.2)).timeout

	if not game_running:
		return

	var missile = missile_scene.instantiate()
	missile.position = spawn_pos
	missile.hit.connect(bird_hit)
	add_child(missile)
	missiles.append(missile)

func bird_hit():
	if game_over:
		return

	game_running = false
	game_over = true
	$PipeTimer.stop()
	$MissileTimer.stop()
	
	$bird.hit()
