extends Area2D

signal card_entered

func _ready():
	pass

func _on_card_area_enter(area):
	if area.get_name() == "card":
		emit_signal("card_entered")
		print("card entered")
