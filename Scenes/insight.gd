extends Label

func _ready():
	g.insightChanged.connect(update)
	update()

func update():
	text = str(g.insight)
