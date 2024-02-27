extends TextureProgressBar


func _ready():
	g.stChanged.connect(update)

func update():
	value = g.stamina * 100 / g.maxst
