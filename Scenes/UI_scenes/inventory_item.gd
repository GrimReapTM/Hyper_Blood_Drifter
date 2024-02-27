extends Control

@export var Sprite: Sprite2D
@export var Amount: Label
@export var Description: Label
@export var Name: Label
@export var button: Button
@export var Price: Label
@export var currency: Sprite2D
@export var ID = ""
@export var type = "inventory"

var vial = false
var bullet = false

@export var a_select: AudioStreamPlayer

var price = 0

func _ready():
	if type == "inventory":
		g.itemAmount.connect(change_amount)
	else:
		g.openShop.connect(change_amount)
	item()

func item():
	if type != "inventory":
		price = g.get_item(ID, "price")
		Price.text = str(price)
		currency.visible = true
		button.disabled = false
	if not vial and not bullet:
		if ID in g.inventory:
			Amount.text = str(g.inventory[ID])
	else:
		if vial:
			Amount.text = str(g.vials)
		elif bullet:
			Amount.text = str(g.bullets)
	Name.text = g.get_item(ID, "name")
	Description.text = g.get_item(ID, "description")
	Sprite.frame = g.get_item(ID, "frame")


func change_amount():
	if not vial and not bullet:
		if ID in g.inventory:
			Amount.text = str(g.inventory[ID])
		else:
			if type == "inventory":
				queue_free()
			else:
				Amount.text = ""
	else:
		if vial:
			if g.vials == 0:
				Amount.text = ""
			else:
				Amount.text = str(g.vials)
		elif bullet:
			if g.bullets == 0:
				Amount.text = ""
			else:
				Amount.text = str(g.bullets)

func _on_button_pressed():
	if type == "inventory":
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
		a_select.play()
	else:
		if g.b_echoes - price >= 0:
			if not vial and not bullet:
				if ID in g.inventory:
					g.inventory[ID] += 1
				else:
					g.inventory[ID] = 1
				Amount.text = str(g.inventory[ID])
				g.next_item = ID
				g.addItem.emit()
				g.beChanged.emit()
				a_select.play()
				g.b_echoes -= price
				g.beChanged.emit()
			else:
				if bullet:
					if g.bullets != g.max_bullets:
						g.bullets += 1
						g.bulletsChanged.emit()
						g.b_echoes -= price
						g.beChanged.emit()
						a_select.play()
						Amount.text = str(g.bullets)
				elif vial:
					if g.vials != g.max_vials:
						g.vials += 1
						g.vialsChanged.emit()
						g.b_echoes -= price
						g.beChanged.emit()
						a_select.play()
						Amount.text = str(g.vials)
