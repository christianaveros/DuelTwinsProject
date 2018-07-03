extends Node2D

const card = preload("res://Entities/card.tscn") #object call

onready var player = {
	1: {
		"score": 0,
		"cards": [
			card.instance(),
			card.instance(),
			card.instance(),
			card.instance(),
			card.instance()
		]
	},
	2: {
		"score": 0,
		"cards": [
			card.instance(),
			card.instance(),
			card.instance(),
			card.instance(),
			card.instance()]
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
		"change turn":	$camera_pos.position = Vector2((control.turn-1)*80, 0)
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
							player[i+1]["cards"][j].change_position(Vector2(32, 16+(40*cnt)))
							card_in_play[j] = player[i+1]["cards"][j]
						elif i+1 == 2:
							player[i+1]["cards"][j].change_position(Vector2(258, 16+(40*cnt)))
							card_in_play[j+3] = player[i+1]["cards"][j]
						cnt += 1
						if cnt > 2: cnt = 0
					else:
						if i+1 == 1:
							player[i+1]["cards"][j].change_position(Vector2(32, -36))
						else:
							player[i+1]["cards"][j].change_position(Vector2(258, -36))
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
	reset_p_button_status()
	reset_p_button_texture()
	reset_g_button_texture()

onready var card_counter = {
	1: 3,
	2: 3
}

onready var card_in_play = {
	0: 0,
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0
}

onready var card_in_grid = {
	0: 0,
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	6: 0,
	7: 0,
	8: 0
}

onready var button_status = [0, 0, 0, 0, 0, 0]
onready var grid_status = [0, 0, 0, 0, 0, 0, 0, 0, 0]

func show_card_status(card_values):
	#display banner
	$UI/confirm_banner.position = Vector2($UI/confirm_banner.position.x+16*sign(1.5-card_values["obj_owner"]), $UI/confirm_banner.position.y)
	$UI/confirm_banner.play("status")
	$UI/confirm_banner.visible = !$UI/confirm_banner.visible
	
	#display exit button for status
	$UI/return_button.position = Vector2($UI/return_button.position.x+16*sign(1.5-card_values["obj_owner"]), $UI/return_button.position.y)
	$UI/return_button.visible = !$UI/return_button.visible
	
	#set and show the card status
	$UI/card_color.position = Vector2($UI/card_color.position.x+24*sign(1.5-card_values["obj_owner"]), $UI/card_color.position.y)
	$UI/card_holder.position = Vector2($UI/card_holder.position.x+24*sign(1.5-card_values["obj_owner"]), $UI/card_holder.position.y)
	$UI/card_color.texture = load("res://Textures/blue.png") if card_values["obj_owner"] == 1 else load("res://Textures/red.png")
	$UI/card_holder/card_avatar.texture = load("res://Textures/"+str(self.card_values[card_values["name"]][0])+".png")
	$UI/card_holder/card_num_left.texture = load("res://Textures/number"+str(card_values["left"])+".png")
	$UI/card_holder/card_num_top.texture = load("res://Textures/number"+str(card_values["top"])+".png")
	$UI/card_holder/card_num_right.texture = load("res://Textures/number"+str(card_values["right"])+".png")
	$UI/card_holder/card_num_bottom.texture = load("res://Textures/number"+str(card_values["bottom"])+".png")
	
	$UI/card_color.visible = !$UI/card_color.visible
	$UI/card_holder.visible = !$UI/card_holder.visible
	$UI/card_holder/card_avatar.visible = !$UI/card_holder/card_avatar.visible
	$UI/card_holder/card_num_left.visible = !$UI/card_holder/card_num_left.visible
	$UI/card_holder/card_num_top.visible = !$UI/card_holder/card_num_top.visible
	$UI/card_holder/card_num_right.visible = !$UI/card_holder/card_num_right.visible
	$UI/card_holder/card_num_bottom.visible = !$UI/card_holder/card_num_bottom.visible
	
	$UI/blurred_bg.visible = !$UI/blurred_bg.visible
	$UI/pause_button.visible = !$UI/pause_button.visible
	
	reset_g_button_texture()
	# enable/disable Game buttons
	for i in range(0, 2):
		for j in range(0, 3):
			get_node("p"+str(i+1)+str(j+1)).disabled = !get_node("p"+str(i+1)+str(j+1)).disabled
	
	for i in range(0, 9):
		get_node("g"+str(i)).disabled = !get_node("g"+str(i)).disabled

func check_available_grid():
	for i in range(0, 9):
		get_node("g"+str(i)).texture_normal = load("res://Textures/select1.png") if grid_status[i] == 0 \
		else load("res://Textures/select2.png") #check if not placed

func reset_g_button_texture():
	for i in range(0, 9):
		get_node("g"+str(i)).texture_normal = load("res://Textures/select2.png")

func reset_p_button_status():
	for i in range(0, 6): button_status[i] = 0

func reset_p_button_texture():
	for i in range(0, 2):
		for j in range(0, 3):
			get_node("p"+str(i+1)+str(j+1)).texture_normal = load("res://Textures/select2.png")

func plus_button_status(num):
	button_status[num] += 1	#increment by 1
	if button_status[num] > 1:
		button_status[num] = 0

func _on_p11_button_up():
	print("pressed p11")
	match(button_status[0]):
		0:
			reset_p_button_texture()
			$p11.texture_normal = load("res://Textures/select1.png")
			check_available_grid()
			reset_p_button_status()
		1:
			reset_g_button_texture()
			reset_p_button_texture()
			show_card_status(card_in_play[0].card_value)
	plus_button_status(0)

func _on_p12_button_up():
	print("pressed p12")
	match(button_status[1]):
		0:
			reset_p_button_texture()
			$p12.texture_normal = load("res://Textures/select1.png")
			check_available_grid()
			reset_p_button_status()
		1:
			reset_p_button_texture()
			show_card_status(card_in_play[1].card_value)
	plus_button_status(1)

func _on_p13_button_up():
	print("p13")
	match(button_status[2]):
		0:
			reset_p_button_texture()
			$p13.texture_normal = load("res://Textures/select1.png")
			check_available_grid()
			reset_p_button_status()
		1:
			reset_p_button_texture()
			show_card_status(card_in_play[2].card_value)
	plus_button_status(2)

func _on_p21_button_up():
	print("p21")
	match(button_status[3]):
		0:
			reset_p_button_texture()
			$p21.texture_normal = load("res://Textures/select1.png")
			check_available_grid()
			reset_p_button_status()
		1:
			reset_p_button_texture()
			show_card_status(card_in_play[3].card_value)
	plus_button_status(3)

func _on_p22_button_up():
	print("p22")
	match(button_status[4]):
		0:
			reset_p_button_texture()
			$p22.texture_normal = load("res://Textures/select1.png")
			check_available_grid()
			reset_p_button_status()
		1:
			reset_p_button_texture()
			show_card_status(card_in_play[4].card_value)
	plus_button_status(4)

func _on_p23_button_up():
	print("p23")
	match(button_status[5]):
		0:
			reset_p_button_texture()
			$p23.texture_normal = load("res://Textures/select1.png")
			check_available_grid()
			reset_p_button_status()
		1:
			reset_p_button_texture()
			show_card_status(card_in_play[5].card_value)
	plus_button_status(5)

func _on_g0_button_up():
	print(button_status)
	if button_status.has(1) and grid_status[0] == 0: #change this
		for i in range(0, 6):
			if button_status[i] == 1:
				print("button: "+str(i))
				print(card_in_play[i].card_value)
				
				#change position and change card values
				card_in_play[i].change_position($g0.rect_position + Vector2(2, 2)) #change this
				card_in_grid[0] = card_in_play[i] #change this
				card_in_grid[0].placed = true #change this, []
				if card_counter[control.turn] < 5:
					card_in_play[i] = player[control.turn]["cards"][card_counter[control.turn]]
					card_counter[control.turn] += 1
					card_in_play[i].change_position(get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).rect_position + Vector2(2, 2))
				else:
					get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).disabled = true
				
				#change grid status
				$g0.texture_hover = load("res://Textures/select2.png") #change this
				grid_status[0] = 1 #change this
				
				#check neighboring grid 1, 3
				if grid_status[1] == 1: #change this
					if card_in_grid[0].card_value["right"] > card_in_grid[1].card_value["left"]: #change this
						card_in_grid[1].card_value["obj_owner"] = control.turn #change this
						card_in_grid[1].set_images() #change this
				
				if grid_status[3] == 1: #change this
					if card_in_grid[0].card_value["bottom"] > card_in_grid[3].card_value["top"]: #change this
						card_in_grid[3].card_value["obj_owner"] = control.turn #change this
						card_in_grid[3].set_images() #change this
				
				#change textures
				reset_g_button_texture()
				reset_p_button_texture()
				reset_p_button_status()
				
				#change camera view and turn
				change_turn()
				change_camera_view("change turn")
				break

func _on_g1_button_up():
	print(button_status)
	if button_status.has(1) and grid_status[1] == 0: #change this
		for i in range(0, 6):
			if button_status[i] == 1:
				print("button: "+str(i))
				print(card_in_play[i].card_value)
				
				#change position and change card values
				card_in_play[i].change_position($g1.rect_position + Vector2(2, 2)) #change this
				card_in_grid[1] = card_in_play[i] #change this
				card_in_grid[1].placed = true #change this, []
				if card_counter[control.turn] < 5:
					card_in_play[i] = player[control.turn]["cards"][card_counter[control.turn]]
					card_counter[control.turn] += 1
					card_in_play[i].change_position(get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).rect_position + Vector2(2, 2))
				else:
					get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).disabled = true
				
				#change grid status
				$g1.texture_hover = load("res://Textures/select2.png") #change this
				grid_status[1] = 1 #change this
				
				#check neighboring grid 0, 2, 4
				if grid_status[0] == 1: #change this
					if card_in_grid[1].card_value["left"] > card_in_grid[0].card_value["right"]: #change this
						card_in_grid[0].card_value["obj_owner"] = control.turn #change this
						card_in_grid[0].set_images() #change this
				
				if grid_status[2] == 1: #change this
					if card_in_grid[1].card_value["right"] > card_in_grid[2].card_value["left"]: #change this
						card_in_grid[2].card_value["obj_owner"] = control.turn #change this
						card_in_grid[2].set_images() #change this
				
				if grid_status[4] == 1: #change this
					if card_in_grid[1].card_value["bottom"] > card_in_grid[4].card_value["top"]: #change this
						card_in_grid[4].card_value["obj_owner"] = control.turn #change this
						card_in_grid[4].set_images() #change this
				
				#change textures
				reset_g_button_texture()
				reset_p_button_texture()
				reset_p_button_status()
				
				#change camera view and turn
				change_turn()
				change_camera_view("change turn")
				break

func _on_g2_button_up():
	print(button_status)
	if button_status.has(1) and grid_status[2] == 0: #change this, []
		for i in range(0, 6):
			if button_status[i] == 1:
				print("button: "+str(i))
				print(card_in_play[i].card_value)
				
				#change position and change card values
				card_in_play[i].change_position($g2.rect_position + Vector2(2, 2)) #change this, g
				card_in_grid[2] = card_in_play[i] #change this, []
				card_in_grid[2].placed = true #change this, []
				if card_counter[control.turn] < 5:
					card_in_play[i] = player[control.turn]["cards"][card_counter[control.turn]]
					card_counter[control.turn] += 1
					card_in_play[i].change_position(get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).rect_position + Vector2(2, 2))
				else:
					get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).disabled = true
				
				#change grid status
				$g2.texture_hover = load("res://Textures/select2.png") #change this, g
				grid_status[2] = 1 #change this, []
				
				#check neighboring grid 1, 5
				if grid_status[1] == 1: #change this
					if card_in_grid[2].card_value["left"] > card_in_grid[1].card_value["right"]: #change this, [], [], [], []
						card_in_grid[1].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[1].set_images() #change this, []
				
				if grid_status[5] == 1: #change this
					if card_in_grid[2].card_value["bottom"] > card_in_grid[5].card_value["top"]: #change this, [], [], [], []
						card_in_grid[5].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[5].set_images() #change this, []
				
				#change textures
				reset_g_button_texture()
				reset_p_button_texture()
				reset_p_button_status()
				
				#change camera view and turn
				change_turn()
				change_camera_view("change turn")
				break

func _on_g3_button_up():
	print(button_status)
	if button_status.has(1) and grid_status[3] == 0: #change this, []
		for i in range(0, 6):
			if button_status[i] == 1:
				print("button: "+str(i))
				print(card_in_play[i].card_value)
				
				#change position and change card values
				card_in_play[i].change_position($g3.rect_position + Vector2(2, 2)) #change this, g
				card_in_grid[3] = card_in_play[i] #change this, []
				card_in_grid[3].placed = true #change this, []
				if card_counter[control.turn] < 5:
					card_in_play[i] = player[control.turn]["cards"][card_counter[control.turn]]
					card_counter[control.turn] += 1
					card_in_play[i].change_position(get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).rect_position + Vector2(2, 2))
				else:
					card_in_grid[3].placed = true #change this, []
					get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).disabled = true
				
				#change grid status
				$g3.texture_hover = load("res://Textures/select2.png") #change this, g
				grid_status[3] = 1 #change this, []
				
				#check neighboring grid 0, 4, 6
				if grid_status[0] == 1: #change this
					if card_in_grid[3].card_value["top"] > card_in_grid[0].card_value["bottom"]: #change this, [], [], [], []
						card_in_grid[0].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[0].set_images() #change this, []
				
				if grid_status[4] == 1: #change this
					if card_in_grid[3].card_value["right"] > card_in_grid[4].card_value["left"]: #change this, [], [], [], []
						card_in_grid[4].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[4].set_images() #change this, []
				
				if grid_status[6] == 1: #change this
					if card_in_grid[3].card_value["bottom"] > card_in_grid[6].card_value["top"]: #change this, [], [], [], []
						card_in_grid[6].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[6].set_images() #change this, []
				
				#change textures
				reset_g_button_texture()
				reset_p_button_texture()
				reset_p_button_status()
				
				#change camera view and turn
				change_turn()
				change_camera_view("change turn")
				break

func _on_g4_button_up():
	print(button_status)
	if button_status.has(1) and grid_status[4] == 0: #change this, []
		for i in range(0, 6):
			if button_status[i] == 1:
				print("button: "+str(i))
				print(card_in_play[i].card_value)
				
				#change position and change card values
				card_in_play[i].change_position($g4.rect_position + Vector2(2, 2)) #change this, g
				card_in_grid[4] = card_in_play[i] #change this, []
				card_in_grid[4].placed = true #change this, []
				if card_counter[control.turn] < 5:
					card_in_play[i] = player[control.turn]["cards"][card_counter[control.turn]]
					card_counter[control.turn] += 1
					card_in_play[i].change_position(get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).rect_position + Vector2(2, 2))
				else:
					get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).disabled = true
				
				#change grid status
				$g4.texture_hover = load("res://Textures/select2.png") #change this, g
				grid_status[4] = 1 #change this, []
				
				#check neighboring grid 1, 3, 5, 7
				if grid_status[1] == 1: #change this, []
					if card_in_grid[4].card_value["top"] > card_in_grid[1].card_value["bottom"]: #change this, [], [], [], []
						card_in_grid[1].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[1].set_images() #change this, []
				
				if grid_status[3] == 1: #change this, []
					if card_in_grid[4].card_value["left"] > card_in_grid[3].card_value["right"]: #change this, [], [], [], []
						card_in_grid[3].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[3].set_images() #change this, []
				
				if grid_status[5] == 1: #change this, []
					if card_in_grid[4].card_value["right"] > card_in_grid[5].card_value["left"]: #change this, [], [], [], []
						card_in_grid[5].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[5].set_images() #change this, []
				
				if grid_status[7] == 1: #change this
					if card_in_grid[4].card_value["bottom"] > card_in_grid[7].card_value["top"]: #change this, [], [], [], []
						card_in_grid[7].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[7].set_images() #change this, []
				
				#change textures
				reset_g_button_texture()
				reset_p_button_texture()
				reset_p_button_status()
				
				#change camera view and turn
				change_turn()
				change_camera_view("change turn")
				break

func _on_g5_button_up():
	print(button_status)
	if button_status.has(1) and grid_status[5] == 0: #change this, []
		for i in range(0, 6):
			if button_status[i] == 1:
				print("button: "+str(i))
				print(card_in_play[i].card_value)
				
				#change position and change card values
				card_in_play[i].change_position($g5.rect_position + Vector2(2, 2)) #change this, g
				card_in_grid[5] = card_in_play[i] #change this, []
				card_in_grid[5].placed = true #change this, []
				if card_counter[control.turn] < 5:
					card_in_play[i] = player[control.turn]["cards"][card_counter[control.turn]]
					card_counter[control.turn] += 1
					card_in_play[i].change_position(get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).rect_position + Vector2(2, 2))
				else:
					get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).disabled = true
				
				#change grid status
				$g5.texture_hover = load("res://Textures/select2.png") #change this, g
				grid_status[5] = 1 #change this, []
				
				#check neighboring grid 2, 4, 8
				if grid_status[2] == 1: #change this, []
					if card_in_grid[5].card_value["top"] > card_in_grid[2].card_value["bottom"]: #change this, [], [], [], []
						card_in_grid[2].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[2].set_images() #change this, []
				
				if grid_status[4] == 1: #change this, []
					if card_in_grid[5].card_value["left"] > card_in_grid[4].card_value["right"]: #change this, [], [], [], []
						card_in_grid[4].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[4].set_images() #change this, []
				
				if grid_status[8] == 1: #change this, []
					if card_in_grid[5].card_value["bottom"] > card_in_grid[8].card_value["top"]: #change this, [], [], [], []
						card_in_grid[8].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[8].set_images() #change this, []
				
				#change textures
				reset_g_button_texture()
				reset_p_button_texture()
				reset_p_button_status()
				
				#change camera view and turn
				change_turn()
				change_camera_view("change turn")
				break

func _on_g6_button_up():
	print(button_status)
	if button_status.has(1) and grid_status[6] == 0: #change this, []
		for i in range(0, 6):
			if button_status[i] == 1:
				print("button: "+str(i))
				print(card_in_play[i].card_value)
				
				#change position and change card values
				card_in_play[i].change_position($g6.rect_position + Vector2(2, 2)) #change this, g
				card_in_grid[6] = card_in_play[i] #change this, []
				card_in_grid[6].placed = true #change this, []
				if card_counter[control.turn] < 5:
					card_in_play[i] = player[control.turn]["cards"][card_counter[control.turn]]
					card_counter[control.turn] += 1
					card_in_play[i].change_position(get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).rect_position + Vector2(2, 2))
				else:
					get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).disabled = true
				
				#change grid status
				$g6.texture_hover = load("res://Textures/select2.png") #change this, g
				grid_status[6] = 1 #change this, []
				
				#check neighboring grid 3, 7
				if grid_status[3] == 1: #change this, []
					if card_in_grid[6].card_value["top"] > card_in_grid[3].card_value["bottom"]: #change this, [], [], [], []
						card_in_grid[3].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[3].set_images() #change this, []
				
				if grid_status[7] == 1: #change this, []
					if card_in_grid[6].card_value["right"] > card_in_grid[7].card_value["left"]: #change this, [], [], [], []
						card_in_grid[7].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[7].set_images() #change this, []
				
				#change textures
				reset_g_button_texture()
				reset_p_button_texture()
				reset_p_button_status()
				
				#change camera view and turn
				change_turn()
				change_camera_view("change turn")
				break

func _on_g7_button_up():
	print(button_status)
	if button_status.has(1) and grid_status[7] == 0: #change this, []
		for i in range(0, 6):
			if button_status[i] == 1:
				print("button: "+str(i))
				print(card_in_play[i].card_value)
				
				#change position and change card values
				card_in_play[i].change_position($g7.rect_position + Vector2(2, 2)) #change this, g
				card_in_grid[7] = card_in_play[i] #change this, []
				card_in_grid[7].placed = true #change this, []
				if card_counter[control.turn] < 5:
					card_in_play[i] = player[control.turn]["cards"][card_counter[control.turn]]
					card_counter[control.turn] += 1
					card_in_play[i].change_position(get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).rect_position + Vector2(2, 2))
				else:
					get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).disabled = true
				
				#change grid status
				$g7.texture_hover = load("res://Textures/select2.png") #change this, g
				grid_status[7] = 1 #change this, []
				
				#check neighboring grid 4, 6, 8
				if grid_status[4] == 1: #change this, []
					if card_in_grid[7].card_value["top"] > card_in_grid[4].card_value["bottom"]: #change this, [], [], [], []
						card_in_grid[4].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[4].set_images() #change this, []
				
				if grid_status[6] == 1: #change this, []
					if card_in_grid[7].card_value["left"] > card_in_grid[6].card_value["right"]: #change this, [], [], [], []
						card_in_grid[6].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[6].set_images() #change this, []
				
				if grid_status[8] == 1: #change this, []
					if card_in_grid[7].card_value["right"] > card_in_grid[8].card_value["left"]: #change this, [], [], [], []
						card_in_grid[8].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[8].set_images() #change this, []
				
				#change textures
				reset_g_button_texture()
				reset_p_button_texture()
				reset_p_button_status()
				
				#change camera view and turn
				change_turn()
				change_camera_view("change turn")
				break

func _on_g8_button_up():
	print(button_status)
	if button_status.has(1) and grid_status[8] == 0: #change this, []
		for i in range(0, 6):
			if button_status[i] == 1:
				print("button: "+str(i))
				print(card_in_play[i].card_value)
				
				#change position and change card values
				card_in_play[i].change_position($g8.rect_position + Vector2(2, 2)) #change this, g
				card_in_grid[8] = card_in_play[i] #change this, []
				card_in_grid[8].placed = true #change this, []
				if card_counter[control.turn] < 5:
					card_in_play[i] = player[control.turn]["cards"][card_counter[control.turn]]
					card_counter[control.turn] += 1
					card_in_play[i].change_position(get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).rect_position + Vector2(2, 2))
				else:
					get_node("p"+str(control.turn)+str(i+1-((control.turn-1)*3))).disabled = true
				
				#change grid status
				$g8.texture_hover = load("res://Textures/select2.png") #change this, g
				grid_status[8] = 1 #change this, []
				
				#check neighboring grid 5, 7
				if grid_status[5] == 1: #change this, []
					if card_in_grid[8].card_value["top"] > card_in_grid[5].card_value["bottom"]: #change this, [], [], [], []
						card_in_grid[5].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[5].set_images() #change this, []
				
				if grid_status[7] == 1: #change this, []
					if card_in_grid[8].card_value["left"] > card_in_grid[7].card_value["right"]: #change this, [], [], [], []
						card_in_grid[7].card_value["obj_owner"] = control.turn #change this, []
						card_in_grid[7].set_images() #change this, []
				
				#change textures
				reset_g_button_texture()
				reset_p_button_texture()
				reset_p_button_status()
				
				#change camera view and turn
				change_turn()
				change_camera_view("change turn")
				break

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

func _on_return_button_released():
	#hide banner
	$UI/confirm_banner.position = Vector2(60, 32)
	$UI/confirm_banner.play("pause")
	$UI/confirm_banner.visible = !$UI/confirm_banner.visible
	
	#hide this button
	$UI/return_button.position = Vector2(87, 5)
	$UI/return_button.visible = !$UI/return_button.visible
	
	#reset position
	$UI/card_color.position = Vector2(60, 32)
	$UI/card_holder.position = Vector2(60, 32)
	
	#hide the overlay, blurred bg and show pause button
	$UI/card_color.visible = !$UI/card_color.visible
	$UI/card_holder.visible = !$UI/card_holder.visible
	$UI/card_holder/card_avatar.visible = !$UI/card_holder/card_avatar.visible
	$UI/card_holder/card_num_left.visible = !$UI/card_holder/card_num_left.visible
	$UI/card_holder/card_num_top.visible = !$UI/card_holder/card_num_top.visible
	$UI/card_holder/card_num_right.visible = !$UI/card_holder/card_num_right.visible
	$UI/card_holder/card_num_bottom.visible = !$UI/card_holder/card_num_bottom.visible
	
	$UI/blurred_bg.visible = !$UI/blurred_bg.visible
	$UI/pause_button.visible = !$UI/pause_button.visible
	
	# enable/disable Game buttons
	for i in range(0, 2):
		for j in range(0, 3):
			get_node("p"+str(i+1)+str(j+1)).disabled = !get_node("p"+str(i+1)+str(j+1)).disabled
	
	for i in range(0, 9):
		get_node("g"+str(i)).disabled = !get_node("g"+str(i)).disabled
	
	print(button_status)
	print(grid_status)