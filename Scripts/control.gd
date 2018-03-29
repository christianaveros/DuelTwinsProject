extends Node

#global vars
onready var player_turn = 1 setget set_player_turn, get_player_turn #P1 = 1, P2 = -1
var player = {
	-1:[0,0,0,0,0,0,0,0,0,0],
	1:[0,0,0,0,0,0,0,0,0,0]
} setget set_player, get_player

#name, left, top, right, bottom
onready var card_values = {
	0:["slime", 3,4,4,4], 1:["tork", 5,1,5,4], 2:["emuk", 4,4,4,3],
	3:["worm", 5,4,8,3], 4:["kobra", 3,7,3,2], 5:["bat", 1,4,1,4],
	6:["seed", 9,9,9,8], 7:["scaven", 3,4,5,3], 8:["zoomba", 5,5,5,5],
	9:["pakkun", 5,6,5,4], 10:["wasp", 4,4,4,8], 11:["skeleton", 3,2,3,2],
	12:["wizard", 1,6,1,2], 13:["octorac", 2,3,2,3], 14:["spider", 7,3,5,5],
	15:["atuin", 6,3,6,5], 16:["hero", 6,7,6,6], 17:["ghost", 10,5,5,5],
	18:["heroine", 5,5,7,8], 19:["clone", 6,6,6,7], 20:["undead_king", 9,6,5,5],
	21:["bahamut", 7,7,10,6], 22:["villain", 5,10,5,10]
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

#set up cards
func set_cards():
	#set random cards
	for y in range(10):
		player[-1][y] = randi()%23 #set random int number
	for y in range(10):
		player[1][y] = randi()%23 #set random int number
	print(player)

func end_turn():
	print("signal received")
	player_turn *= -1
	
func _ready():
	randomize() #randomize seed
	print("Master Control: Ready!")
	set_cards()
	set_physics_process(true)

func _physics_process(delta):
	get_node("player").set_text("Player: " + str(player_turn))

