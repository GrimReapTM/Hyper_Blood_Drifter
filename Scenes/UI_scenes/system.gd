extends Control

@export var player: CharacterBody2D
@export var a_close: AudioStreamPlayer
@export var Paused: Control

func _ready():
	player.pause_pressed.connect(close)

func close():
	if visible:
		a_close.play()
		visible = false
		Paused.visible = true
		player.HUD.visible = true
		player.paused = true


#vypne hru 👍
func _on_button_pressed():
	get_tree().quit()


