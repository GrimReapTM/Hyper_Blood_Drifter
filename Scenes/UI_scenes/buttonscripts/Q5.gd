extends TextureButton


@export var pause: Control
@export var label: Label
func hover():
	if is_hovered():
		pause.quickitems.emit()
		label.text = "Empty"

func _process(delta):
	hover()
