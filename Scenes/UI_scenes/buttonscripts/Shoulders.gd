extends TextureButton


@export var pause: Control
@export var label: Label
func hover():
	if is_hovered():
		pause.armor.emit()
		label.text = "Torso"

func _process(delta):
	hover()
