extends CanvasLayer

@onready var points_label: Label = $Control/Label
@onready var health_bar: ProgressBar = $Control/ProgressBar

func _ready() -> void:
	# Connect the HUD to listen to the GameManager's signals
	GameManager.score_updated.connect(update_score_display)
	GameManager.health_updated.connect(update_health_display)
	
	# Set the initial score text when the level loads
	points_label.text = "Points: " + str(GameManager.points)

func update_score_display(new_score: int) -> void:
	points_label.text = "Points: " + str(new_score)

func update_health_display(current_health: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
