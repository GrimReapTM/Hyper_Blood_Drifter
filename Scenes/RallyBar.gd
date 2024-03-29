extends TextureProgressBar

@export var healthBar: TextureProgressBar
@export var stop = true


func _ready():
	value = g.hp * 100 / g.maxhp
	g.hpChanged.connect(update)
	update()

func update():
	$RallyTimer.start()

func _on_rally_timer_timeout():
	if value != healthBar.value and stop:
		stop = false

func _process(delta):
	if not stop:
		if value >= healthBar.value:
			value -= g.maxhp / 100 * delta * 7
		else:
			value = healthBar.value
			stop = true




