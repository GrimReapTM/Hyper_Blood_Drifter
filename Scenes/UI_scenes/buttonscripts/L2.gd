extends TextureButton


@export var pause: Control
@export var label: Label
func hover():
	if is_hovered():
		pause.weapons.emit()
		label.text = "Left hand 2"

func _process(delta):
	hover()
