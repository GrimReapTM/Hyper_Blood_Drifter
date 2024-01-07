extends TextureButton


@export var pause: Control
@export var label: Label
func hover():
	if is_hovered():
		pause.weapons.emit()
		label.text = "Left hand 1"

func _process(delta):
	hover()
