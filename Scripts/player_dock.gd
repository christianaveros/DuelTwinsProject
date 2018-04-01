extends Node2D

#const card_default = preload("res://Entities/card_default.tscn")
var player_ind = 0 # not onready for this is needed to be assigned!

func _ready():
	#connect areas to positions
	#var pos = {
		#0:get_node("position 0/area"),
		#1:get_node("position 1/area"),
		#2:get_node("position 2/area")
	#}
	#for x in range(3):
		#pos[x].connect("card_entered", self, "_on_card_area_entered")
	#set_process_input(true)
	#set_physics_process(true)
	pass
	

#func _physics_process(delta):
	#print(position) # print position
	#print(player_ind) #print player owner
	#pass

#func _input(event):
	#print(event.position)
	#print(position) # print position
	#position = get_viewport().get_mouse_position()
	#pass

#func _on_card_area_entered(area):
	#if area.get_name() == "card": # if a card enters
		#print(area.get_name())
	#pass # replace with function body
