extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_VEL : int = 650
const FLAP_SPEED : int = -440
var flying : bool = false
var falling : bool = false
const START_POS = Vector2(100, 300)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

#move bird to starting pos
func reset() -> void:
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)
	

#bird states
func _physics_process(delta) -> void:
	if flying or falling:
		velocity.y += GRAVITY * delta
		
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		move_and_slide()
		
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
	else: 
		$AnimatedSprite2D.stop()

#flap upwards on click
func flap() -> void:
	velocity.y = FLAP_SPEED
	
#stop bird movement
func hit() -> void:
	velocity = Vector2.ZERO
	flying = false
	falling = true
	$AnimatedSprite2D.stop()
	
