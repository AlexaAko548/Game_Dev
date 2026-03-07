extends CanvasLayer
# Making this reusable again! You can type the specific level name in the Inspector.
@export var level_name: String = "Level 2"

@onready var label: Label = $Label

func _ready() -> void:
	# Set the text to whatever you typed in the Inspector
	label.text = level_name
	
	# Start the text completely transparent (Alpha = 0)
	label.modulate.a = 0.0 
	
	# Create our animation tween
	var tween = get_tree().create_tween()
	
	# 1. Fade in to fully visible over 1 second
	tween.tween_property(label, "modulate:a", 1.0, 1.0)
	
	# 2. Keep it on screen for 2 seconds (a pause)
	tween.tween_interval(2.0)
	
	# 3. Fade it back out to invisible over 1 second
	tween.tween_property(label, "modulate:a", 0.0, 1.0)
