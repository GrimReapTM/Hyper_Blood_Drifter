extends Control

@export var player: CharacterBody2D
@export var a_close: AudioStreamPlayer
@export var Paused: Control

@export var HP: Label
@export var ST: Label
@export var W1: Label
@export var W2: Label
@export var Beast: Label

@export var Lv: Label
@export var Be: Label
@export var In: Label
@export var Vit: Label
@export var End: Label
@export var Str: Label
@export var Bld: Label


func _on_visibility_changed():
	HP.text = str(g.hp) + "/" + str(g.maxhp)
	ST.text = str(g.maxst)
	W1.text = str(g.melee_damage)
	W2.text = str(g.ranged_damage)
	Beast.text = str(g.max_beast_damage)
	
	Lv.text = str(g.Level)
	Be.text = str(g.b_echoes)
	In.text = str(g.insight)
	Vit.text = str(g.Vitality)
	End.text = str(g.Endurance)
	Str.text = str(g.Strength)
	Bld.text = str(g.Bloodtinge)


func _ready():
	g.hpChanged.connect(updatehp)
	player.pause_pressed.connect(close)

func updatehp():
	HP.text = str(g.hp) + "/" + str(g.maxhp)

func close():
	if visible:
		a_close.play()
		visible = false
		Paused.visible = true
		player.HUD.visible = true
		player.paused = true


