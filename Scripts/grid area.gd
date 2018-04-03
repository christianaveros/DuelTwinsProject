extends Area2D

onready var within_area = 0
onready var occupied = 0
const AREA_OFFSET = 8
onready var grid_dock = get_node("../")
var card = preload("res://Entities/card_default.tscn").instance()

func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	if within_area == 1:
		#print("Distance: ", get_viewport().get_mouse_position().distance_to(grid_dock.position+position))#Vector2(grid_dock.position.x + position.x, grid_dock.position.y + position.y)))
		if get_viewport().get_mouse_position().distance_to(grid_dock.position+position) < AREA_OFFSET:
			if card.pressed == 1: #print(card.get_name())
				card.within_area = 1
				card.area_pos = grid_dock.position+position
				card.placed = 1
			
			#print("within area!")

func area_entered(area):
	if area.get_name() != get_name():
		print("area entered: ===== ", get_name())
		print("card: ", area.get_node("../").get_name())
		card = area.get_node("../") 
		within_area = 1
	pass

func mouse_entered():
	control.area = self
	within_area = 1
	print("mouse entered "+get_name()+" at"+str(get_viewport().get_mouse_position()))
	pass

func mouse_exited():
	control.area = self
	within_area = -1
	print("mouse exited "+get_name()+" at"+str(get_viewport().get_mouse_position()))
	pass