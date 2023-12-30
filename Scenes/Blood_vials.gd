extends Label

@export var player: CharacterBody2D
@export var vials: Sprite2D

func _ready():
	text = str(player.b_vials)
	player.vialsChanged.connect(update)
	update()

func update():
	var fifth = int(player.max_b_vials/5)
	text = str(player.b_vials)
	
	if player.b_vials == 0:
		vials.frame = 5
	elif player.b_vials == fifth:
		vials.frame = 4
	elif player.b_vials == 2*fifth:
		vials.frame = 3
	elif player.b_vials == 3*fifth:
		vials.frame = 2
	elif player.b_vials == 4*fifth:
		vials.frame = 1
	elif player.b_vials == 5*fifth:
		vials.frame = 0
