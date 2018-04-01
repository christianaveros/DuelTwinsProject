extends Area2D

const CARD_OFFSET = 8

func _ready():
	pass

func area_entered(area, area_x, area_y): # if signal area_entered is emitted print this
	var card = get_node("../")
	card.within_area = 1 # indicate that the card is within an area
	if card.pressed == 1:
		card.area_pos = Vector2(area_x, area_y)
		print("card enter while card is pressed")
	pass

func mouse_exited(area_x, area_y): # if signal area_entered is emitted print this
	var card = get_node("../")
	if card.pressed == 1: # area exited while carrying the card
		card.within_area = 0
		card.area_pos = get_viewport().get_mouse_position()
		print("card exited while card is pressed")
	else:
		card.area_pos = Vector2(area_x, area_y)
		print("mouse exited while no card is pressed")
	pass
