extends Node2D

var missile_difficulty_timer := 0.0
var difficulty_timer:= 0.0
var distance_score := 0.0
var game_running : bool
var game_over : bool
var scroll
var score
var scroll_speed := 8.0
var screen_size : Vector2i
var ground_height : int

@export var warning_scene : PackedScene

@export var missile_scene : PackedScene
var missiles : Array

@export var pipe_scene : PackedScene
var pipes : Array
const PIPE_DELAY : int = 50
const PIPE_RANGE : int = 200


func _ready() -> void:
	screen_size = get_window().size
	new_game()

func new_game() -> void:
	#reset values
	$BGMusic.play()
	$HUD.new_game()
	game_running = false
	game_over = false
	scroll_speed = 8
	distance_score = 0
	missile_difficulty_timer = 0
	score = 0
	scroll = 0
	$PipeTimer.wait_time = 1
	$MissileTimer.wait_time = 8
	$Bird.reset()
	$HUD.update_score(0)
	$Background.stop()
	
	#cleans obstacles on-screen
	for p in pipes:
		if is_instance_valid(p):
			p.queue_free()
	pipes.clear()
	
	for m in missiles:
		if is_instance_valid(m):
			m.queue_free()
	missiles.clear()

func _input(event) -> void:
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false :
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()


func start_game() -> void:
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$HUD.start_game()
	$PipeTimer.start()
	$MissileTimer.start()
	$Background.start()
	
func _process(delta: float) -> void:
	if not game_running:
		return
	
	#update score based on scroll speed
	distance_score += scroll_speed * delta
	score = int(distance_score)
	$HUD.update_score(score)
	
	#difficulty scaling by adjusting wait time between spawners
	#stops timer if value is above 2.5 to prevent pipe instakill
	#Decrease Missile spawn interval to adjust difficulty
	difficulty_timer += delta
	if difficulty_timer >= 5:
		difficulty_timer = 0
		$PipeTimer.wait_time = max(2.5, $PipeTimer.wait_time * 1.09)
		$MissileTimer.wait_time = min(2.5, $MissileTimer.wait_time * 0.99)
		if $PipeTimer.wait_time >= 2.5:
			$PipeTimer.stop()
			$MissileTimer.wait_time = min(3, $MissileTimer.wait_time * 0.99)
			if $MissileTimer.wait_time <= 2:
				$MissileTimer.wait_time = 2
	
	#Difficulty debugger: 
	print($PipeTimer.wait_time)
	print($MissileTimer.wait_time)
	print(difficulty_timer)
	
	#screen scrollspeed scaling
	scroll_speed += delta * 0.5
	scroll += scroll_speed
	if scroll >= screen_size.x:
		scroll = 0
	$Ground.position.x = -scroll
	
	#moves obstacles
	for pipe in pipes:
		pipe.position.x -= scroll_speed
	
	for missile in missiles:
		missile.position.x -= scroll_speed + 10
		
	#Clean up if obstacles are out of screen
	for i in range(pipes.size() - 1, -1, -1):
		if is_instance_valid(pipes[i]) and pipes[i].position.x < -200:
			pipes[i].queue_free()
			pipes.remove_at(i)
			
	for i in range(missiles.size() - 1, -1, -1):
		if is_instance_valid(missiles[i]) and missiles[i].position.x < -200:
			missiles[i].queue_free()
			missiles.remove_at(i)

#basis for pipe spawn interval
func _on_pipe_timer_timeout() -> void:
	generate_pipes()
	
#pipe generator
func generate_pipes() -> void:	
	var pipe = pipe_scene.instantiate()
	pipe.orientation = randi_range(0, 4)
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = pipe_position()
	pipe.hit.connect(bird_hit)
	add_child(pipe)
	pipes.append(pipe)

func pipe_position() -> int:
	var pos : int = randi_range(1, 3)
	var pipe_pos : int	
	match pos:
		1: 
			pipe_pos = 680
		2:
			pipe_pos = 180
		3:
			pipe_pos = 400
	return pipe_pos

#basis for missile spawn interval
func _on_missile_timer_timeout() -> void:
	generate_missile()

#missile generator
func generate_missile() -> void:
	var burst_type = randi() % 3 
	
	match burst_type:
		0:
			await single_missile()
		1:
			await triple_burst()
		2:
			await rapid_burst()
			
#missile behaviors
func single_missile():
	await spawn_missile()

func triple_burst():
	for i in 3:
		await spawn_missile()
		await get_tree().create_timer(0.2).timeout

func rapid_burst():
	for i in 5:
		await spawn_missile()
		await get_tree().create_timer(0.08).timeout
		

#missile spawn instance
func spawn_missile() -> void:
	var spawn_pos = Vector2(
		screen_size.x - 50,
		clamp($Bird.position.y, 100, screen_size.y - 60)
	)

	var warning = warning_scene.instantiate()
	warning.position = spawn_pos
	add_child(warning)

	await get_tree().create_timer(randf_range(0.3, 1.2)).timeout

	if not game_running:
		return

	var missile = missile_scene.instantiate()
	missile.position = spawn_pos

	missile.hit.connect(bird_hit)
	add_child(missile)
	missiles.append(missile)

#bird hit stops game
func bird_hit() -> void:
	game_running = false
	game_over = true
	$HUD.reset_game()
	$PipeTimer.stop()
	$MissileTimer.stop()
	$Bird.hit()
	$Background.stop()

	
