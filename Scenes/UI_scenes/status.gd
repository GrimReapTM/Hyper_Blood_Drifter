extends Control

@export var player: CharacterBody2D
@export var a_close: AudioStreamPlayer
@export var Paused: Control

func _ready():
	player.pause_pressed.connect(close)

func close():
	a_close.play()
	visible = false
	Paused.visible = true
	player.HUD.visible = true
	player.paused = true
