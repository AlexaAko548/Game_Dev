extends CharacterBody2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var max_health: int = 3
var current_health: int = 3
var is_hurt: bool = false
var is_dead: bool = false
const GAME_OVER_SCREEN = preload("res://scenes/game_over_scene.tscn")
const KNOCKBACK_VELOCITY = 500.0
const SPEED = 400.0
const JUMP_VELOCITY = -900.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	# This ensures the HUD is fully loaded before the player shouts its health!
	GameManager.health_updated.emit.call_deferred(current_health, max_health)

func _physics_process(delta: float) -> void:
	#Animations
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "idle"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		# Only play the jump animation if we aren't hurt
		if not is_hurt:
			sprite_2d.animation = "jumping"
			
	# --- NEW CODE: LOCK INPUT IF HURT ---
	if is_hurt:
		# If the player is bouncing backwards, skip all the input code below
		# and just apply the physics!
		move_and_slide()
		return
	
	# --- NEW CODE: STOP MOVEMENT IF DEAD ---
	if is_dead:
		# Keep applying gravity so they fall if they die mid-air, but skip the rest!
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$jumpSound.play() # Play the jump sound!

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actios with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 10)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft


func take_damage(amount: int, trap_x_pos: float = 0.0) -> void:
	# If we are already hurt and bouncing, ignore the damage! (Invincibility frames)
	if is_hurt:
		return 
	
	$hurtSound.play() # Play the hurt sound!
	
	current_health -= amount
	GameManager.health_updated.emit(current_health, max_health)
	
	if current_health <= 0:
		die()
	else:
		apply_knockback(trap_x_pos)

func apply_knockback(trap_x_pos: float) -> void:
	is_hurt = true
	
	# Bounce the player up in the air slightly
	velocity.y = JUMP_VELOCITY * 0.7 
	
	# Check where the trap is to bounce the player in the opposite direction
	if global_position.x < trap_x_pos:
		velocity.x = -KNOCKBACK_VELOCITY # Bounce Left
	else:
		velocity.x = KNOCKBACK_VELOCITY  # Bounce Right
		
	# Turn the player red to show they got hurt!
	sprite_2d.modulate = Color(1, 0, 0)
	
	# Wait for 0.4 seconds (This is the duration of the knockback)
	await get_tree().create_timer(0.4).timeout
	
	# Return the player to normal color and give them control back
	sprite_2d.modulate = Color(1, 1, 1)
	is_hurt = false

func die() -> void:
	# Prevent this from triggering twice if they hit two traps at once
	if is_dead: return 
	
	is_dead = true
	print("Player died!")
	
	# 1. Stop horizontal movement instantly
	velocity.x = 0 
	
	# 2. Play the animation and the sound
	sprite_2d.animation = "death"
	$deathSound.play()
	
	# 3. Wait for 1.5 seconds so the player can process what happened
	await get_tree().create_timer(1.5).timeout
	
	# 4. Spawn the Game Over screen onto the screen!
	var game_over = GAME_OVER_SCREEN.instantiate()
	get_tree().current_scene.add_child(game_over)
