extends Node

#global vars
onready var player_turn = 1 setget set_player_turn, get_player_turn #P1 = 1, P2 = -1
var player = {
	-1:[0,0,0,0,0,0,0,0,0,0],
	1:[0,0,0,0,0,0,0,0,0,0]
} setget set_player, get_player
var s_card = [0,0,0,0,0,0] setget set_s_card, get_s_card
const dock = preload("res://Entities/player_dock.tscn") #object call
const card = preload("res://Entities/card_default.tscn") #object call

#name, left, top, right, bottom
onready var card_values = {
	1:["slime", 3,4,4,4], 2:["tork", 5,1,5,4], 3:["emuk", 4,4,4,3],
	4:["worm", 5,4,8,3], 5:["kobra", 3,7,3,2], 6:["bat", 1,4,1,4],
	7:["seed", 9,9,9,8], 8:["scaven", 3,4,5,3], 9:["zoomba", 5,5,5,5],
	10:["pakkun", 5,6,5,4], 11:["wasp", 4,4,4,8], 12:["skeleton", 3,2,3,2],
	13:["wizard", 1,6,1,2], 14:["octorac", 2,3,2,3], 15:["spider", 7,3,5,5],
	16:["atuin", 6,3,6,5], 17:["hero", 6,7,6,6], 18:["ghost", 10,5,5,5],
	19:["heroine", 5,5,7,8], 20:["clone", 6,6,6,7], 21:["undead_king", 9,6,5,5],
	22:["bahamut", 7,7,10,6], 23:["villain", 5,10,5,10]
}

#set player turn
func set_player_turn(value):
	player_turn = value
#get player turn
func get_player_turn():
	return player_turn

#set player
func set_player(value):
	player = value
#get player
func get_player():
	return player

#set s_cards
func set_s_card(value):
	s_card = value
#get s_cards
func get_s_card():
	return s_card

#set up cards
func set_cards():
	#set random cards
	var val = 0
	var x = 24
	for y in range(10):
		var b = true
		while b == true:
			val = randi()%x
			if !player[-1].has(val):
				player[-1][y] = val
				b = false
		b = true
		while b == true:
			val = randi()%x
			if !player[1].has(val):
				player[1][y] = val
				b = false
	#print(card_values) #card values
	#set 3 starting cards
	var arr_size = 10
	for x in range(3):
		s_card[x] = player[-1][randi()%arr_size] #set random from before
		s_card[(s_card.size() -1) - x] = player[1][randi()%arr_size]
		arr_size -= 1
	
	#print test
	print(s_card)
	print(player)
	
	#create 2 player docks
	var dock_1 = dock.instance()
	dock_1.player_ind = 1
	dock_1.position = Vector2(230,28) #get_viewport().size.x*.25, get_viewport().size.y*.8
	get_node("/root/game_scene").add_child(dock_1)
	#print(dock_1.position)
	var dock_2 = dock.instance()
	dock_2.player_ind = -1
	dock_2.position = Vector2(26,32) #get_viewport().size.x*.25, get_viewport().size.y*.8
	get_node("/root/game_scene").add_child(dock_2)
	#print(dock_2.position)
	
	#create cards
	var card1_0 = card.instance()

func end_turn():
	print("signal received")
	player_turn *= -1
	
func _ready():
	randomize() #randomize seed
	set_cards() #create cards
	set_physics_process(true)
	print("Master Control: Ready!")

func _physics_process(delta):
	#label for turn
	var player_num = player_turn if player_turn == 1 else 2
	get_node("player").set_text("Player " + str(player_num) + "'s Turn")

