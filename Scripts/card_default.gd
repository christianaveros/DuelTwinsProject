extends Control

const CARD_OFFSET = 16 # extent area
var player_ind = 1 # need to be assigned
var monster_name = "" # need to be assigned 
var stats = [0,0,0,0] # need to be assigned
onready var pressed = -1 # -1, not_pressed, 1, pressed

func _ready():
	get_node("left").set_text(str(stats[0]))
	get_node("top").set_text(str(stats[1]))
	get_node("right").set_text(str(stats[2]))
	get_node("bottom").set_text(str(stats[3]))
	set_process_input(true)
	set_physics_process(true)

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
	
	
	