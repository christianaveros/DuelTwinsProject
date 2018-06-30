extends Node2D

const card = preload("res://Entities/card.tscn") #object call

onready var player = {
	1: {
		"score": 0, "cards": [card.instance(),card.instance(),card.instance(),card.instance(),card.instance()]
	},
	2: {
		"score": 0, "cards": [card.instance(),card.instance(),card.instance(),card.instance(),card.instance()]
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
	control.turn = control.g_turn
	change_camera_view("game start")
	set_cards()

func change_camera_view(var mode = "pause"):
	match(mode):
		"pause":	$camera_pos.position = Vector2(40, 0)
		"unpause":	$camera_pos.position = Vector2((control.turn-1)*80, 0)
		"game start":	$camera_pos.position = Vector2((control.g_turn-1)*80, 0)

func set_cards():
	# set card min and max strenths level
	var MIN = 1+(control.difficulty-1)*6 if control.difficulty != 4 else 0 #1, 7, 13, 0
	var MAX = 13+(control.difficulty-1)*5 if control.difficulty != 4 else 23 # 13, 18, 23, 23
	print("MIN:"+str(MIN))
	print("MAX:"+str(MAX))
	# true randomize numbers
	randomize()
	
	var rand_val = 0
	var in_array = false
	var arr = [[0,0,0,0,0], [0,0,0,0,0]]
	var cnt = 0
	
	for i in range(0, 2):
		for j in range(0, 5):
			rand_val = 0
			in_array = false
			while in_array == false:
				rand_val = randi()%(MAX-MIN) + MIN
				if !arr[i].has(rand_val): #check if value is already set before
					arr[i][j] = rand_val #set
					add_child(player[i+1]["cards"][j])
					player[i+1]["cards"][j].setValues(rand_val, i+1)
					if i+1 != control.g_turn:
						player[i+1]["cards"][j].holder.texture = load("res://Textures/card_back.png")
						player[i+1]["cards"][j].avatar.visible = !player[i+1]["cards"][j].avatar.visible
						player[i+1]["cards"][j].color.visible = !player[i+1]["cards"][j].color.visible
						player[i+1]["cards"][j].left.visible = !player[i+1]["cards"][j].left.visible
						player[i+1]["cards"][j].top.visible = !player[i+1]["cards"][j].top.visible
						player[i+1]["cards"][j].right.visible = !player[i+1]["cards"][j].right.visible
						player[i+1]["cards"][j].bottom.visible = !player[i+1]["cards"][j].bottom.visible
					if j < 3:
						if i+1 == 1: #respawn in
							player[i+1]["cards"][j].change_position(32, 16+(40*cnt))
							card_in_play[j] = player[i+1]["cards"][j]
						elif i+1 == 2:
							player[i+1]["cards"][j].change_position(258, 16+(40*cnt))
							card_in_play[j+3] = player[i+1]["cards"][j]
						cnt += 1
						if cnt > 2: cnt = 0
					else:
						if i+1 == 1:
							player[i+1]["cards"][j].change_position(32, -36)
						else:
							player[i+1]["cards"][j].change_position(258, -36)
					in_array = true #proceed

func change_turn():
	#disable other players Game button
	for j in range(0, 5):
		if player[control.turn]["cards"][j].placed == false:
			player[control.turn]["cards"][j].holder.texture = load("res://Textures/card_back.png")
			player[control.turn]["cards"][j].avatar.visible = !player[control.turn]["cards"][j].avatar.visible
			player[control.turn]["cards"][j].color.visible = !player[control.turn]["cards"][j].color.visible
			player[control.turn]["cards"][j].left.visible = !player[control.turn]["cards"][j].left.visible
			player[control.turn]["cards"][j].top.visible = !player[control.turn]["cards"][j].top.visible
			player[control.turn]["cards"][j].right.visible = !player[control.turn]["cards"][j].right.visible
			player[control.turn]["cards"][j].bottom.visible = !player[control.turn]["cards"][j].bottom.visible
	control.turn += 1			#change turn
	if control.turn > 2:		#change turn
		control.turn = 1		#change turn
	print("turn: " + str(control.turn))
	for j in range(0, 5):
		if player[control.turn]["cards"][j].placed == false:
			player[control.turn]["cards"][j].holder.texture = load("res://Textures/card_placeholder.png")
			player[control.turn]["cards"][j].avatar.visible = !player[control.turn]["cards"][j].avatar.visible
			player[control.turn]["cards"][j].color.visible = !player[control.turn]["cards"][j].color.visible
			player[control.turn]["cards"][j].left.visible = !player[control.turn]["cards"][j].left.visible
			player[control.turn]["cards"][j].top.visible = !player[control.turn]["cards"][j].top.visible
			player[control.turn]["cards"][j].right.visible = !player[control.turn]["cards"][j].right.visible
			player[control.turn]["cards"][j].bottom.visible = !player[control.turn]["cards"][j].bottom.visible

onready var card_in_play = {
	0: 0,
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0
}

func _on_p11_button_up():
	print("p11")

func _on_p12_button_up():
	print("p12")

func _on_p13_button_up():
	print("p13")

func _on_p21_button_up():
	print("p21")

func _on_p22_button_up():
	print("p22")

func _on_p23_button_up():
	print("p23")

#----------------------------------UI-buttons-----------------------------

func _on_pause_button_released():
	# display banner
	$UI/confirm_banner.play("pause")
	$UI/confirm_banner.visible = !$UI/confirm_banner.visible
	
	# display/hide UI buttons
	$UI/pause_button.visible = !$UI/pause_button.visible
	$UI/blurred_bg.visible = !$UI/blurred_bg.visible
	$UI/play_button.visible = !$UI/play_button.visible
	$UI/reset_button.visible = !$UI/reset_button.visible
	$UI/back_button.visible = !$UI/back_button.visible
	
	# change card visibility and camera pos
	
	for j in range(0, 5):
		if player[control.turn]["cards"][j].placed == false:
			player[control.turn]["cards"][j].holder.texture = load("res://Textures/card_back.png") \
			if $UI/confirm_banner.visible == true else load("res://Textures/card_placeholder.png")
			player[control.turn]["cards"][j].avatar.visible = !player[control.turn]["cards"][j].avatar.visible
			player[control.turn]["cards"][j].color.visible = !player[control.turn]["cards"][j].color.visible
			player[control.turn]["cards"][j].left.visible = !player[control.turn]["cards"][j].left.visible
			player[control.turn]["cards"][j].top.visible = !player[control.turn]["cards"][j].top.visible
			player[control.turn]["cards"][j].right.visible = !player[control.turn]["cards"][j].right.visible
			player[control.turn]["cards"][j].bottom.visible = !player[control.turn]["cards"][j].bottom.visible
	
	# enable/disable Game buttons
	for i in range(0, 2):
		for j in range(0, 3):
			get_node("p"+str(i+1)+str(j+1)).disabled = !get_node("p"+str(i+1)+str(j+1)).disabled
	
	for i in range(0, 9):
		get_node("g"+str(i)).disabled = !get_node("g"+str(i)).disabled
	
	if !$UI/confirm_banner.visible: change_turn()
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