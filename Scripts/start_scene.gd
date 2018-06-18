extends Node2D

onready var difficulty = 1
onready var turn = 1

func _ready():
	$difficulty_button.normal = load("res://Textures/menu_difficulty"+str(difficulty)+".png")
	$difficulty_button.pressed = load("res://Textures/menu_difficulty"+str(difficulty+1)+".png")
	pass

func _on_start_button_released():
	# move to game stage
	get_tree().change_scene("res://Stages/game_scene.tscn")

func _on_exit_button_released(): 
	#exit game
	get_tree().quit()


func _on_difficulty_button_released():
	difficulty += 2
	if difficulty > 8:
		difficulty = 1
	$difficulty_button.normal = load("res://Textures/menu_difficulty"+str(difficulty)+".png")
	$difficulty_button.pressed = load("res://Textures/menu_difficulty"+str(difficulty+1)+".png")


func _on_turn_button_released():
	turn += 2
	if turn > 3:
		turn = 1
	$turn_button.normal = load("res://Textures/menu_turn"+str(turn)+".png")
	$turn_button.pressed = load("res://Textures/menu_turn"+str(turn+1)+".png")