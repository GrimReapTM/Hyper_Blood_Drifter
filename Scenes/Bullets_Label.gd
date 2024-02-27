extends Label

func _ready():
	g.bulletsChanged.connect(update)
	update()

func update():
	text = str(g.bullets)
	if g.bullets == g.max_bullets:
		label_settings.font_color = Color("87b5ed")
	else:
		label_settings.font_color = Color("fefcf6")
