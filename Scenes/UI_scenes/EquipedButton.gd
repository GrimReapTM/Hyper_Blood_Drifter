extends TextureButton

signal is_press

func _ready():
	self.pressed.connect(self._button_pressed)
	

func _button_pressed():
	is_press.emit()
