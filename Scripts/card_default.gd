extends Control

const CARD_OFFSET = 16
onready var player_ind = 1
onready var pressed = -1

func _ready():
	set_process_input(true)
	set_physics_process(true)
	if player_ind == 1:
		get_node("card_area/player_ind").set_texture(load("res://Textures/red.png"))
	else:
		get_node("card_area/player_ind").set_texture(load("res://Textures/blue.png"))

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and !event.is_echo() and player_ind == control.player_turn:
		if (rect_position.x-CARD_OFFSET < event.position.x) and (rect_position.x+CARD_OFFSET > event.position.x)\
		and (rect_position.y-CARD_OFFSET < event.position.y) and (rect_position.y+CARD_OFFSET > event.position.y):
			pressed *= -1
			print("pressed")

func _physics_process(delta):
	#drag
	if pressed == 1:
		rect_position = get_viewport().get_mouse_position()
	
	#check nearby object
	