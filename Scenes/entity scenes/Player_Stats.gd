extends Node

@export var player: CharacterBody2D


func _ready():
	g.beChanged.connect(be)
	g.iChanged.connect(i)
	g.hpChanged.connect(hpsig)


func be():
	player.b_echoes = g.b_echoes
	player.b_echoesChanged.emit()

func i():
	player.insight = g.insight
	player.insightChanged.emit()

func hpsig():
	player.healthPoints = g.hp
	player.healthChanged.emit()

func _process(_delta):

	g.position = player.position
	g.fire_damage = player.fire_damage
	g.b_echoes = player.b_echoes
	g.insight = player.insight
	g.hp = player.healthPoints
	g.stamina = player.stamina
