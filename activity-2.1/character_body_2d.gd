extends CharacterBody2D

# --- 1. THE FINITE STATE MACHINE ---
enum State { PATROL, AGGRO, CHASE }
var current_state: State = State.PATROL

# --- 2. VARIABLES ---
const PATROL_SPEED = 60.0
const CHASE_SPEED = 90.0 # Make it run slightly faster when chasing!

@export var patrol_distance: float = 100.0 
var start_x: float 
var direction = -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# This will hold the player so the slime knows who to chase
var player_target: Node2D = null 

# --- 3. NODE REFERENCES ---
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ledge_check: RayCast2D = $LedgeCheck
@onready var wall_check: RayCast2D = $WallCheck

func _ready() -> void:
	start_x = global_position.x

func _physics_process(delta: float) -> void:
	# Always apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# --- THIS IS THE "BRAIN" ---
	match current_state:
		State.PATROL:
			process_patrol()
		State.AGGRO:
			velocity.x = 0 # Stand completely still while yelling!
		State.CHASE:
			process_chase()

	# Apply the movement!
	move_and_slide()

# --- AI BEHAVIOR: PATROL ---
func process_patrol() -> void:
	animated_sprite_2d.play("enemy") # Play patrol animation
	velocity.x = direction * PATROL_SPEED
	
	# Turn around if it goes too far left or right
	if global_position.x <= start_x - patrol_distance:
		direction = 1
		update_visuals()
	elif global_position.x >= start_x + patrol_distance:
		direction = -1
		update_visuals()
		
	# Backup RayCasts
	if ledge_check.is_colliding() or wall_check.is_colliding():
		direction *= -1
		update_visuals()

# --- AI BEHAVIOR: CHASE (PATHFINDING) ---
func process_chase() -> void:
	animated_sprite_2d.play("chase")
	
	if player_target != null:
		# Find the path: subtract enemy position from player position to get direction
		var direction_to_player = sign(player_target.global_position.x - global_position.x)
		
		velocity.x = direction_to_player * CHASE_SPEED
		
		# Flip visuals to face the player
		if direction_to_player != 0:
			direction = direction_to_player
			update_visuals()
			
		# AI Failsafe: Stop at the edge so it doesn't run off a cliff while chasing!
		if ledge_check.is_colliding() or wall_check.is_colliding():
			velocity.x = 0

# --- HELPER FUNCTION: FLIP EYES AND SPRITE ---
func update_visuals() -> void:
	if direction == 1: # Facing Right
		animated_sprite_2d.flip_h = false
		ledge_check.position.x = abs(ledge_check.position.x)
		wall_check.target_position.x = abs(wall_check.target_position.x)
	elif direction == -1: # Facing Left
		animated_sprite_2d.flip_h = true
		ledge_check.position.x = -abs(ledge_check.position.x)
		wall_check.target_position.x = -abs(wall_check.target_position.x)

# --- SENSOR: PLAYER ENTERS VISION ---
# --- SENSOR: PLAYER ENTERS VISION ---
func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_target = body
		
		# 1. Switch to the new AGGRO state so it stops moving
		current_state = State.AGGRO
		
		# 2. Play the surprise/angry animation!
		animated_sprite_2d.play("aggro")
		
		# 3. Wait right here in the code until that specific animation finishes
		await animated_sprite_2d.animation_finished
		
		# 4. Make sure the player didn't already run away during the animation
		if player_target != null:
			current_state = State.CHASE

# --- SENSOR: PLAYER LEAVES VISION ---
func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_target = null
		current_state = State.PATROL
		start_x = global_position.x
# --- DAMAGE (Keep your exact code!) ---
func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(20, global_position.x)
