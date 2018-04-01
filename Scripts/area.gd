extends Area2D

const offset = 12
onready var parent_pos = { # 'x' = x, 'y' = y
	'x': get_parent().position.x,
	'y': get_parent().position.y
}

func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	#if get_viewport().get_mouse_position().x < parent_pos['x']+offset and get_viewport().get_mouse_position().x > parent_pos['x']-offset\
	#	and get_viewport().get_mouse_position().y < parent_pos['y']+offset and get_viewport().get_mouse_position().y > parent_pos['y']-offset:
	#		print(get_parent().get_name() + ", the parent position: " + str(parent_pos))
	#		print(self.get_name() + ", the child position: " + str(position))
	pass