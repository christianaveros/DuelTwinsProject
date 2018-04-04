extends Node

#global vars
onready var player_turn = 1 setget set_player_turn, get_player_turn #P1 = 1, P2 = -1

#create 2 player docks
export onready var docks = {
	1: dock.instance(),
	0: grid_dock.instance(),
	-1: dock.instance()
}
export onready var player_num = {
	-1: "Blue",
	1: "Red"
}
onready var dir = {
	0:"left",
	1:"top",
	2:"right",
	3:"bottom"
}
export(int) onready var x_pos = {
	1: 230-32,
	-1: 26+32
}

var player = {
	-1:[0,0,0,0,0,0,0,0,0,0],
	1:[0,0,0,0,0,0,0,0,0,0]
} setget set_player, get_player

var s_card = [0,0,0,0,0,0,0,0,0,0] setget set_s_card, get_s_card
const dock = preload("res://Entities/player_dock.tscn") #object call
const grid_dock = preload("res://Entities/grid_dock.tscn") # object call
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

onready var handle = card.instance()
var area = ""
onready var selecting_card = 1 # selecting 1, not selecting

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
	
	#set 3 starting cards
	var arr_size = 5
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
	
	
	var y_offset = 40
	for z in [-1, 1]:
		docks[z].player_ind = z
		docks[z].position = Vector2(x_pos[z], 32) #get_viewport().size.x*.25, get_viewport().size.y*.8
		get_node("/root/game_scene").add_child(docks[z])
	
	#create cards
	var cards = {
		1:[card.instance(), card.instance(), card.instance()],
		-1:[card.instance(), card.instance(), card.instance()]
	}
	# set card 1, -1
	for z in [-1, 1]:
		for y in range(3): #0-2
			cards[z][y].player_ind = z # player owned for sprite
			cards[z][y].monster_name = card_values[s_card[y if z == 1 else y+3]][0] # monster name for sprite
			#cards[z][y].placed = -1
			cards[z][y].get_node("card_area/card_holder/card_sprite").set_texture(load(str("res://Textures/"+cards[z][y].monster_name+".png")))
			#for w in range(3):
			#	cards[z][y].get_node("card_area").connect("area_entered", docks[z].get_node("position "+str(w)+"/area"), "area_entered", [x_pos[z], 32+docks[z].get_node("position "+str(w)).position.y])
			#	cards[z][y].get_node("card_area").connect("mouse_exited", docks[z].get_node("position "+str(w)+"/area"), "mouse_exited", [x_pos[z], 32+docks[z].get_node("position "+str(w)).position.y])
			#	docks[z].get_node("position "+str(w)+"/area").connect("area_entered", cards[z][y].get_node("card_area"), "area_entered", [docks[z].get_node("position "+str(w)+"/area"), x_pos[z], 32+docks[z].get_node("position "+str(w)).position.y])
			#	docks[z].get_node("position "+str(w)+"/area").connect("mouse_exited", cards[z][y].get_node("card_area"), "mouse_exited", [docks[z].get_node("position "+str(w)+"/area"), x_pos[z], 32+docks[z].get_node("position "+str(w)).position.y])
			docks[z].get_node("position "+str(y)+"/area").connect("area_entered", cards[z][y].get_node("card_area"), "area_entered", [docks[z].get_node("position "+str(y)+"/area"), x_pos[z], 32+docks[z].get_node("position "+str(y)).position.y])
			docks[z].get_node("position "+str(y)+"/area").connect("mouse_exited", cards[z][y].get_node("card_area"), "mouse_exited", [docks[z].get_node("position "+str(y)+"/area"), x_pos[z], 32+docks[z].get_node("position "+str(y)).position.y])
			for x in range(4): #[0] = [1] 0,1,2,3 = 1,2,3,4
				cards[z][y].stats[x] = card_values[s_card[y if z == 1 else y+3]][x+1]
				cards[z][y].get_node(dir[x]).set_text(str(cards[z][y].stats[x]))
			cards[z][y].rect_position = Vector2(x_pos[z], 32+docks[z].get_node("position "+str(y)).position.y)# place at position y
			cards[z][y].area_pos = Vector2(x_pos[z], 32+docks[z].get_node("position "+str(y)).position.y)
			get_node("/root/game_scene").add_child(cards[z][y]) # add chil
			print("card "+str(y)+": "+cards[z][y].monster_name+" stats: "+str(cards[z][y].stats)+" position:"+str(cards[z][y].rect_position)) # debug mode
		#cards[z][0].get_node("card_area").connect("area_entered", docks[z].get_node("position "+str(w)+"/area"), "area_entered", [x_pos[z], 32+docks[z].get_node("position "+str(w)).position.y])
	
	# grid
	docks[0].position = Vector2(79+15, 23+15)
	for x in range(9):
		docks[0].get_node("area "+str(x)).connect("mouse_entered", docks[0].get_node("area "+str(x)), "mouse_entered")
		docks[0].get_node("area "+str(x)).connect("area_entered", docks[0].get_node("area "+str(x)), "area_entered")
		docks[0].get_node("area "+str(x)).connect("mouse_exited", docks[0].get_node("area "+str(x)), "mouse_exited")
	get_node("/root/game_scene").add_child(docks[0])

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
	get_node("player turn label").set_text(player_num[player_turn] + "'s Turn")
	#print(handle)

func area_0(area_card, right_card, bottom_card):
	print("FUNCTION: area 0 "+area_card.get_name()+" stats: "+str(area_card.stats))
	print("Right Card: ", right_card)
	print("Bottom Card: ", bottom_card)
	pass

func area_1(area_card, left_card, right_card, bottom_card):
	print("FUNCTION: area 1 "+area_card.get_name()+" stats: "+str(area_card.stats))
	print("Left Card: ", left_card)
	print("Right Card: ", right_card)
	print("Bottom Card: ", bottom_card)
	pass

func area_2(area_card, left_card, bottom_card):
	print("FUNCTION: area 2 "+area_card.get_name()+" stats: "+str(area_card.stats))
	print("Left Card: ", left_card)
	print("Bottom Card: ", bottom_card)
	pass

func area_3(area_card, top_card, right_card, bottom_card):
	print("FUNCTION: area 3 "+area_card.get_name()+" stats: "+str(area_card.stats))
	print("Top Card: ", top_card)
	print("Right Card: ", right_card)
	print("Bottom Card: ", bottom_card)
	pass

func area_4(area_card, top_card, left_card, right_card, bottom_card):
	print("FUNCTION: area 4 "+area_card.get_name()+" stats: "+str(area_card.stats))
	print("Top Card: ", top_card)
	print("Left Card: ", left_card)
	print("Right Card: ", right_card)
	print("Bottom Card: ", bottom_card)
	pass

func area_5(area_card, top_card, left_card, bottom_card):
	print("FUNCTION: area 5 "+area_card.get_name()+" stats: "+str(area_card.stats))
	print("Top Card: ", top_card)
	print("Left Card: ", left_card)
	print("Bottom Card: ", bottom_card)
	pass

func area_6(area_card, top_card, right_card):
	print("FUNCTION: area 6"+area_card.get_name()+" stats: "+str(area_card.stats))
	print("Top Card: ", top_card)
	print("Right Card: ", right_card)
	pass

func area_7(area_card, top_card, left_card, right_card):
	print("FUNCTION: area 7 "+area_card.get_name()+" stats: "+str(area_card.stats))
	print("Top Card: ", top_card.monster_name)
	print("Left Card: ", left_card.monster_name)
	print("Right Card: ", right_card.monster_name)
	pass

func area_8(area_card, top_card, left_card):
	print("FUNCTION: area 8, "+area_card.get_name()+" stats: "+str(area_card.stats))
	print("Top Card: ", top_card.monster_name)
	print("Left Card: ", left_card.monster_name)
	pass
