extends Node2D

#global vars
onready var turn = 1 #P1 = 1, P2 = -1
onready var difficulty = 1

const card = preload("res://Entities/card.tscn") #object call

onready var player = {
	1: {
		"score": 0, "cards": [0,0,0,0,0]
	},
	2: {
		"score": 0, "cards": [0,0,0,0,0]
	}
}

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

func _ready():
	change_camera_view("turn change")
	set_cards()

func set_cards():
	# set card min and max strenths level
	var MIN = 1+(difficulty-1)*6 if difficulty != 4 else 0 #1, 7, 13, 0
	var MAX = 13+(difficulty-1)*5 if difficulty != 4 else 23 # 13, 18, 23, 23
	
	# true randomize numbers
	randomize()
	
	var rand_val = 0
	var in_array = false
	
	for i in range(0, 2):
		for j in range(0, 5):
			rand_val = 0
			in_array = false
			while in_array == false:
				rand_val = randi()%MAX + MIN
				if !player[i+1]["cards"].has(rand_val): #check if value is already set before
					player[i+1]["cards"][j] = rand_val #set
					in_array = true #proceed
			print(player[i+1]["cards"][j])

func change_turn():
	turn += 1
	if turn > 2:
		turn = 1

func change_camera_view(var mode = "pause"):
	$camera_pos.position = Vector2(40, 0) if mode == "pause" else Vector2((turn-1)*80, 0)

#----------------------------------UI-buttons-----------------------------

func _on_pause_button_released():
	# display banner
	$UI/confirm_banner.play("pause")
	$UI/confirm_banner.visible = !$UI/confirm_banner.visible
	
	# display buttons
	$UI/pause_button.visible = !$UI/pause_button.visible
	$UI/blurred_bg.visible = !$UI/blurred_bg.visible
	$UI/play_button.visible = !$UI/play_button.visible
	$UI/reset_button.visible = !$UI/reset_button.visible
	$UI/back_button.visible = !$UI/back_button.visible
	
	# change card visibility and camera pos
	change_camera_view("pause" if $UI/confirm_banner.visible else "unpause")

func _on_reset_button_released():
	# display banner
	$UI/confirm_banner.play("reset")
	
	# display button
	$UI/confirm_button.visible = !$UI/confirm_button.visible
	$UI/cancel_button.visible = !$UI/cancel_button.visible
	
	# remove extra buttons
	$UI/play_button.visible = !$UI/play_button.visible
	$UI/reset_button.visible = !$UI/reset_button.visible
	$UI/back_button.visible = !$UI/back_button.visible

func _on_back_button_released():
	# display banner
	$UI/confirm_banner.play("quit")
	
	# display buttons
	$UI/confirm_button.visible = !$UI/confirm_button.visible
	$UI/cancel_button.visible = !$UI/cancel_button.visible
	
	# remove extra buttons
	$UI/play_button.visible = !$UI/play_button.visible
	$UI/reset_button.visible = !$UI/reset_button.visible
	$UI/back_button.visible = !$UI/back_button.visible

func _on_confirm_button_released():
	if $UI/confirm_banner.animation == "reset":
		get_tree().reload_current_scene()
	elif $UI/confirm_banner.animation == "quit":
		get_tree().change_scene("res://Stages/start_scene.tscn")

func _on_cancel_button_released():
	# display banner
	$UI/confirm_banner.play("pause")
	
	# remove buttons
	$UI/confirm_button.visible = !$UI/confirm_button.visible
	$UI/cancel_button.visible = !$UI/cancel_button.visible
	
	# display extra buttons
	$UI/play_button.visible = !$UI/play_button.visible
	$UI/reset_button.visible = !$UI/reset_button.visible
	$UI/back_button.visible = !$UI/back_button.visible
