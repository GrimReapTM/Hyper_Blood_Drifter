extends TextureButton

signal is_press

func _ready():
	self.pressed.connect(self._button_pressed)
	

func _button_pressed():
	is_press.emit()

@export var pause: Control
@export var label: Label
func hover():
	if is_hovered():
		pause.debug.emit()
		label.text = "Settings"


func _process(delta):
	hover()
