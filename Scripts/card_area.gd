extends Area2D

func _ready():
	pass

func display_position(area): # if signal area_entered is emitted print this
	#if area.get_name() == "area":
	print("entered: ", str(area.get_name()) + " at: "+str(area.position))

func display_position2(area): # if signal area_entered is emitted print this
	#if area.get_name() == "area":
	print("exited: " + str(area.get_name()) + " at: "+str(area.position))
