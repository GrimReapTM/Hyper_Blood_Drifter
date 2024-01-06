extends Control

var any_button_pressed = false

@export var any_button: Label
signal press

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			if not any_button_pressed:
				any_button_pressed = true
				any_button.visible = false
				press.emit()
