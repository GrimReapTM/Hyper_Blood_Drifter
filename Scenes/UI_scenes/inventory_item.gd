extends Control

@export var Sprite: Sprite2D
@export var Amount: Label
@export var Description: Label
@export var Name: Label
@export var button: Button
@export var ID = ""


func _ready():
	g.itemAmount.connect(change_amount)
	item()

func item():
	Amount.text = str(g.inventory[ID])
	Name.text = g.get_item(ID, "name")
	Description.text = g.get_item(ID, "description")
	Sprite.frame = g.get_item(ID, "frame")

func change_amount():
	if ID in g.inventory:
		Amount.text = str(g.inventory[ID])
	else:
		queue_free()


func _on_button_pressed():
	if ID not in g.quick_slots:
		g.quick_slots[g.next_slot] = ID
		g.changeSprite.emit()
	else:
		var index = g.quick_slots.find(ID)
		g.quick_slots[index] = null
		g.quick_slots[g.next_slot] = ID
		g.old_slot = index
		g.changeSprite.emit()
	g.showHud.emit()
