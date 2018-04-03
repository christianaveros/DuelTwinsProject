extends Area2D

onready var occupied = 1 # 1 = occupied, -1 = not_occupied

func _ready():
	#set_physics_process(true)
	pass

#func _physics_process(delta):
	#if get_viewport().get_mouse_position().x < parent_pos['x']+offset and get_viewport().get_mouse_position().x > parent_pos['x']-offset\
	#	and get_viewport().get_mouse_position().y < parent_pos['y']+offset and get_viewport().get_mouse_position().y > parent_pos['y']-offset:
	#		print(get_parent().get_name() + ", the parent position: " + str(parent_pos))
	#		print(self.get_name() + ", the child position: " + str(position))
	#pass

#func area_entered(area, target_x, target_y):
#	print(area.get_name()+" area entered area: "+str(get_node("../").position))

#func mouse_exited(target_x, target_y):
#	print("mouse exited area "+str(Vector2(target_x, target_y))+" at"+str(get_viewport().get_mouse_position()))