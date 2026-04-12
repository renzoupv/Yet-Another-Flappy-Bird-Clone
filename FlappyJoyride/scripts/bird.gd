extends CharacterBody2D

const GRAVITY := 1000.0
const MAX_VEL := 500.0
const FLAP_SPEED := -400.0
const START_POS := Vector2(100, 300)

var alive := false
var game_started := false

func _ready():
	add_to_group("player")
	reset()

func reset():
	position = START_POS
	velocity = Vector2.ZERO
	rotation = 0
	alive = false
	game_started = false
	$AnimatedSprite2D.stop()

func start():
	game_started = true
	alive = true

func _physics_process(delta):
	# If game hasn’t started, do nothing
	if not game_started:
		return

	# Gravity always applies once started
	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, MAX_VEL)

	move_and_slide()

	rotation = clamp(
		deg_to_rad(velocity.y * 0.05),
		deg_to_rad(-30),
		deg_to_rad(90)
	)

	if alive:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

func flap():
	if not alive:
		return
	velocity.y = FLAP_SPEED

func hit():
	alive = false
