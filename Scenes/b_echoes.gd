extends Label

func _ready():
	g.b_echoesChanged.connect(update)
	update()

func update():
	text = str(g.b_echoes)
