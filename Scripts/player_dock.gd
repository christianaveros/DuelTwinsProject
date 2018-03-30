extends Node2D

const card_default = preload("res://Entities/card_default.tscn")
var player_ind = 0 # not onready for this is needed to be assigned!

func _ready():
	#create s_cards
	set_process_input(true)
	set_physics_process(true)

func _physics_process(delta):
	#print(position) # print position
	#print(player_ind) #print player owner
	get_node("position 0").position = position
	get_node("position 1").position = Vector2(position.x, 40)
	get_node("position 2").position = Vector2(position.x, 80)
	
	pass

func _input(event):
	#print(event.position)
	#print(position) # print position
	#position = get_viewport().get_mouse_position()
	print(get_node("position 0").position)
	print(get_node("position 1").position)
	print(get_node("position 2").position)
	pass