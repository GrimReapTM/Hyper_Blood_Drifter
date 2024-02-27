extends Node

'''@export var player: CharacterBody2D


func _ready():
	g.max_vials = player.max_b_vials
	g.max_bullets = player.maxBullets
	g.maxhp = player.maxHealthPoints
	g.maxst = player.maxStamina
	g.beChanged.connect(be)
	g.iChanged.connect(i)
	g.hpChanged.connect(hpsig)
	g.maxhpChanged.connect(hpmaxsig)
	g.maxstChanged.connect(stmaxsig)
	g.maxvialsChanged.connect(vialsig)
	g.maxbulletsChanged.connect(bullsig)


func hpmaxsig():
	player.maxHealthPoints = g.maxhp

func stmaxsig():
	player.maxStamina = g.maxst

func vialsig():
	player.max_b_vials = g.max_vials

func bullsig():
	player.maxBullets = g.max_bullets


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
'''
