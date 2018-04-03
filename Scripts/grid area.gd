extends Area2D

onready var within_area = 0
onready var occupied = 0
const AREA_OFFSET = 12
onready var card = ""

func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	if get_viewport().get_mouse_position().distance_to(position) < AREA_OFFSET:
		within_area = 1
		print("same as mouse enters")
	

func area_entered(area):
	print(area.get_node("../").get_name())
	card = area.get_node("../")
	#if within_area == 1:
	#	print("area entered: "+str(area.get_node("../").get_name()))
	#print("occupied:", occupied)
	pass

func mouse_entered():
	print("mouse entered")
	pass

func mouse_exited():
	print("mouse exited")
	pass