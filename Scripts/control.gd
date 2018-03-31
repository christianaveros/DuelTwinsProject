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
	13:["wizard", 1,6,1,2], 14:["octoroc", 2,3,2,3], 15:["spider", 7,3,5,5],
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
	var x = 23 # max letter
	var b = true #iterate remover checker
	for y in range(10):
		b = true
		while b == true:
			val = randi()%x+1 #1, ..., 23
			if !player[-1].has(val): #check if value is already set before
				player[-1][y] = val #set
				b = false #proceed
		b = true
		while b == true:
			val = randi()%x+1
			if !player[1].has(val):
				player[1][y] = val
				b = false
	#print(card_values) #card values
	
	#set 3 starting cards
	var arr_size = 10
	for x in range(3):
		val = randi()%arr_size
		s_card[x] = player[-1][val] #set random from before
		player[-1].remove(val) # remove in array
		val = randi()%arr_size
		s_card[3+x] = player[1][val]
		player[1].remove(val)
		arr_size -= 1
	
	#print test
	print("all starting cards: ", s_card)
	print("all players cards: ", player)
	
	#create 2 player docks
	var docks = {
		1: dock.instance(),
		-1: dock.instance()
	} 
	var x_pos = {
		1: 230,
		-1: 26
	}
	var y_offset = 40
	for z in [-1, 1]:
		docks[z].player_ind = z
		docks[z].position = Vector2(x_pos[z], 32) #get_viewport().size.x*.25, get_viewport().size.y*.8
		for x in range(3):
			#docks[z].get_node("position "+str(x)).position = Vector2(x_pos[z], y_pos[z]+(y_offset*x))
			#docks[z].get_node("position "+str(x)+"/area").position = Vector2(0, y_offset*x)#docks[z].get_node("position "+str(x)).position
			#var children = docks[z].get_node("position "+str(x)+"/area").get_children()
			#for y in range(2): #sprite, shape
				#children[y].position = docks[z].get_node("position "+str(x)).position
			print(docks[z].get_node("position "+str(x)).position)
		get_node("/root/game_scene").add_child(docks[z])
	
	#create cards
	var cards = {
		1:[card.instance(), card.instance(), card.instance()],
		-1:[card.instance(), card.instance(), card.instance()]
	}
	var dir = {
		0:"left",
		1:"top",
		2:"right",
		3:"bottom"
	}
	# set card 1, -1
	for z in [-1, 1]:
		for y in range(3): #0-2
			cards[z][y].player_ind = z # player owned for sprite
			cards[z][y].monster_name = card_values[s_card[y if z == 1 else y+3]][0] # monster name for sprite
			for x in range(4): #[0] = [1] 0,1,2,3 = 1,2,3,4
				cards[z][y].stats[x] = card_values[s_card[y if z == 1 else y+3]][x+1]
				cards[z][y].get_node(dir[x]).set_text(str(cards[z][y].stats[x]))
			cards[z][y].rect_position = Vector2(x_pos[z], 32+docks[z].get_node("position "+str(y)).position.y)# place at position y
			var game_scene_node = get_node("/root/game_scene")
			game_scene_node.add_child(cards[z][y]) # add child
			docks[z].get_node("position "+str(y)+"/area").connect("area_entered", cards[z][y].get_node("card_area"), "display_position")
			docks[z].get_node("position "+str(y)+"/area").connect("area_exited", cards[z][y].get_node("card_area"), "display_position2")
			print("card "+str(y)+": "+cards[z][y].monster_name+" stats: "+str(cards[z][y].stats)+" position:"+str(cards[z][y].rect_position)) # debug mode

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

