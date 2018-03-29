extends Area2D


func _ready():
	set_process_input(true)

func _input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		print("clicked")