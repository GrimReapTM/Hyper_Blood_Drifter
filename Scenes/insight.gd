extends Label

func _ready():
	g.iChanged.connect(update)
	update()

func update():
	text = str(g.insight)
