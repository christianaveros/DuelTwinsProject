extends KinematicBody2D

func _ready():
	#set up all card here
	pass

func change_color():
	get_node("player_ind").set_texture(load("res://Textures/red.png"))
