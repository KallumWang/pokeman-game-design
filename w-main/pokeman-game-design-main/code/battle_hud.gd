extends CanvasLayer

@onready var counter_label = $TrainerCounter

func _process(_delta):
	# Using the list size to show progress. 
	# If each trainer counts as 2, we divide by 2 for the display.
	var count = Global.defeated_trainers.size() / 2
	counter_label.text = "Trainers: " + str(count) + "/3"
