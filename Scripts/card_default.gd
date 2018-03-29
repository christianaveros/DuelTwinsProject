extends Control

const card_offset = 16
onready var player_turn = get_node("/root/control").get_player_turn()
onready var player_ind = get_node("/root/control").get_player()
onready var pressed = -1

func _ready():
	if player_ind == 1:
		get_node("card_area/player_ind").set_texture(load("res://Textures/red.png"))
	else:
		get_node("card_area/player_ind").set_texture(load("res://Textures/blue.png"))
	set_process_input(true)
	set_physics_process(true)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and !event.is_echo():
		if (rect_position.x-card_offset < event.position.x) and (rect_position.x+card_offset > event.position.x)\
		and (rect_position.y-card_offset < event.position.y) and (rect_position.y+card_offset > event.position.y):
			pressed *= -1
			print("pressed")

func _physics_process(delta):
	player_ind = get_node("/root/control").player_turn
	#drag
	if pressed == 1:
		rect_position = get_viewport().get_mouse_position()
	