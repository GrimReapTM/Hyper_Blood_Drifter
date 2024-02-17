extends Control

var any_button_pressed = false

@export var any_button: Label
@export var a_move: AudioStreamPlayer
@export var a_ok: AudioStreamPlayer
@export var a_any_button: AudioStreamPlayer
@export var a_cancel: AudioStreamPlayer

signal press

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			if not any_button_pressed:
				any_button_pressed = true
				any_button.visible = false
				press.emit()
				a_any_button.play()



func _on_play_pressed():
	a_ok.play()
	get_tree().change_scene_to_file("res://Scenes/areas/Dream.tscn")

func _on_quit_pressed():
	a_ok.play()
	get_tree().quit()


func _on_play_mouse_entered():
	a_move.play()

func _on_quit_mouse_entered():
	a_move.play()
