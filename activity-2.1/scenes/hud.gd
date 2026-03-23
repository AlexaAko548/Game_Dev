extends CanvasLayer

@onready var points_label: Label = $Control/Label
@onready var hearts_container: HBoxContainer = $Control/HeartsContainer

func _ready() -> void:
	# Connect the HUD to listen to the GameManager's signals
	GameManager.score_updated.connect(update_score_display)
	GameManager.health_updated.connect(update_health_display)
	
	# Set the initial score text when the level loads
	points_label.text = "Points: " + str(GameManager.points)

func update_score_display(new_score: int) -> void:
	points_label.text = "Points: " + str(new_score)

func update_health_display(current_health: int, max_health: int) -> void:
	# Grab all the heart icons we placed inside the HBoxContainer
	var hearts = hearts_container.get_children()
	
	# Loop through them and turn them on/off based on your current health
	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].show() # We have health, show the heart!
		else:
			hearts[i].hide() # We lost this health point, hide the heart!
