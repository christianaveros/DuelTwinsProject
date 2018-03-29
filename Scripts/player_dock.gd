extends Node2D

const card_default = preload("res://Entities/card_default.tscn")
onready var player_ind = 0

func _ready():
	#create s_cards
	set_physics_process(true)

func _physics_process(delta):
	pass
