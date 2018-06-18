extends KinematicBody2D

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

onready var card_colors = {
	1: "blue",
	2: "red"
}

onready var card_value = {
	obj_owner: 0,
	name: 0,
	left: 0,
	top: 0,
	right: 0,
	bottom: 0
}

onready var color = $card_color
onready var holder = $card_holder
onready var avatar = $card_holder/card_avatar
onready var left = $card_holder/card_num_left
onready var top = $card_holder/card_num_top
onready var right = $card_holder/card_num_right
onready var bottom = $card_holder/card_num_bottom

func _ready(var num = 1, var obj_owner = 1):
	# debug purposes
	randomize()
	num = randi()%23 + 1
	obj_owner = randi()%2 + 1
	
	# card initialization
	card_value["obj_owner"] = obj_owner
	card_value["name"] = num
	card_value["left"] = card_values[card_value["name"]][1]
	card_value["top"] = card_values[card_value["name"]][2]
	card_value["right"] = card_values[card_value["name"]][3]
	card_value["bottom"] = card_values[card_value["name"]][4]
	set_card_images()

func set_card_images():
	color.texture = load("res://Textures/"+str(card_colors[card_value["obj_owner"]])+".png") #color
	avatar.texture = load("res://Textures/"+str(card_values[card_value["name"]][0])+".png") #monster avatar
	left.texture = load("res://Textures/number"+str(card_value["left"])+".png")
	top.texture = load("res://Textures/number"+str(card_value["top"])+".png")
	right.texture = load("res://Textures/number"+str(card_value["right"])+".png")
	bottom.texture = load("res://Textures/number"+str(card_value["bottom"])+".png")

