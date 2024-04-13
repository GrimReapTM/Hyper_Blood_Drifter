extends Label

@export var vials: Sprite2D

func _ready():
	text = str(g.vials)
	g.vialsChanged.connect(update)
	update()

# changes the label color and sprite depending on vial amount
func update():
	var fifth = int(g.max_vials/5)
	text = str(g.vials)
	if g.vials == g.max_vials:
		label_settings.font_color = Color("87b5ed")
	else:
		label_settings.font_color = Color("fefcf6")
	
	if g.vials == 0:
		vials.frame = 5
	elif g.vials == fifth:
		vials.frame = 4
	elif g.vials == 2*fifth:
		vials.frame = 3
	elif g.vials == 3*fifth:
		vials.frame = 2
	elif g.vials == 4*fifth:
		vials.frame = 1
	elif g.vials == 5*fifth:
		vials.frame = 0
