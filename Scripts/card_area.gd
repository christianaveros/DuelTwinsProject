extends Area2D

const CARD_OFFSET = 8
onready var card = get_node("../")
func _ready():
	pass

func area_entered(area, target, target_x, target_y): # if signal area_entered is emitted print this
	card.within_area = 1 # indicate that the card is within an area
	if card.pressed == 1:# and target.occupied == -1:
		card.area_pos = Vector2(target_x, target_y)
		print("card enter while card is pressed")#, no one is occupying this")
	pass

func mouse_exited(area, target_x, target_y): # if signal area_entered is emitted print this
	if card.pressed == 1: # area exited while carrying the card
		card.within_area = -1
		print("card exited while card is pressed")
	else:
		print("mouse exited while no card is pressed")
	pass
