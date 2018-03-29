extends KinematicBody2D

func _ready():
	set_process_input(true)

func change_color():
	get_node("card_area/player_ind").set_texture(load("res://Textures/red.png"))
