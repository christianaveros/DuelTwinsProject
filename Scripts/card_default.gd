extends Control

const CARD_OFFSET = 12 # extent area
var player_ind = 0 # need to be assigned
var monster_name = "" # need to be assigned 
var stats = [0,0,0,0] # need to be assigned

#area related
onready var within_area = 1
var area_pos = Vector2(0,0) setget set_area_pos, get_area_pos
onready var pressed = -1 # -1, not_pressed, 1, pressed

func _ready():
	set_process_input(true)
	set_physics_process(true)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and !event.is_echo() and player_ind == control.player_turn:
		if (rect_position.x-CARD_OFFSET < event.position.x) and (rect_position.x+CARD_OFFSET > event.position.x)\
		and (rect_position.y-CARD_OFFSET < event.position.y) and (rect_position.y+CARD_OFFSET > event.position.y):
			pressed *= -1
			if pressed == 1:
				print("pressed")
			else:
				print("released")

func _physics_process(delta):
	if within_area == 1 and pressed == -1:
		rect_position = area_pos # stay
	elif pressed == 1: # drag
		if get_viewport().get_mouse_position().distance_to(area_pos) > CARD_OFFSET: #within_area == 1:
			rect_position = get_viewport().get_mouse_position() # !within_area, pos = mouse pos
		else:
			rect_position = area_pos # stay
	
	#set color
	if player_ind == 1:
		get_node("card_area/player_ind").set_texture(load("res://Textures/red.png"))
	else:
		get_node("card_area/player_ind").set_texture(load("res://Textures/blue.png"))
		
	#set monster sprite
	if monster_name == "":
		get_node("card_area/card_holder/card_sprite").set_texture(load("res://Textures/unknown.png"))
	else:
		get_node("card_area/card_holder/card_sprite").set_texture(load(str("res://Textures/"+monster_name+".png")))

func set_area_pos(value):
	area_pos = value

func get_area_pos():
	return area_pos
