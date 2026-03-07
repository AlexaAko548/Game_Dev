extends Node
# These signals shout to the rest of the game when something changes
signal score_updated(new_score: int)
signal health_updated(current_health: int, max_health: int)
signal player_died

var points = 0
var points_at_level_start = 0 # This is our new memory variable!

func add_point():
	points += 1
	print("Points: ", points)
	score_updated.emit(points)

# We will call this right when a level begins
func save_level_score():
	points_at_level_start = points

# We will call this right when the player dies
func reset_level_score():
	points = points_at_level_start
	# Shout out the reset score so the HUD updates instantly
	score_updated.emit(points)
