extends Label

func _ready():
	g.beChanged.connect(update)
	update()

func update():
	text = str(g.b_echoes)
