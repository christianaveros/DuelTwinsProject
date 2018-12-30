extends Node2D

func _ready():
	control.turn = control.g_turn
	$turn_button.normal = load("res://Textures/menu_turn"+str(control.turn+(control.turn-1))+".png")
	$turn_button.pressed = load("res://Textures/menu_turn"+str(control.turn+1+(control.turn-1))+".png")
	$difficulty_button.normal = load("res://Textures/menu_difficulty"+str(control.difficulty)+".png")
	$difficulty_button.pressed = load("res://Textures/menu_difficulty"+str(control.difficulty+1)+".png")

func _on_start_button_released():
	# move to game stage
	get_tree().change_scene("res://Stages/game_scene.tscn")

func _on_exit_button_released(): 
	#exit game
	get_tree().quit()

func _on_difficulty_button_released():
	control.difficulty += 1
	if control.difficulty > 4:
		control.difficulty = 1
	$difficulty_button.normal = load("res://Textures/menu_difficulty"+str(1+(control.difficulty-1)*2)+".png")
	$difficulty_button.pressed = load("res://Textures/menu_difficulty"+str(2+(control.difficulty-1)*2)+".png")

func _on_turn_button_released():
	control.turn += 1
	control.g_turn += 1
	if control.turn > 2 and control.g_turn > 2:
		control.turn = 1
		control.g_turn = 1
	$turn_button.normal = load("res://Textures/menu_turn"+str(control.turn+(control.turn-1))+".png")
	$turn_button.pressed = load("res://Textures/menu_turn"+str(control.turn+1+(control.turn-1))+".png")

func _on_info_button_released():
	get_tree().change_scene("res://Stages/info_scene.tscn")
