extends Control

@export var messengers: StaticBody2D
@export var player: CharacterBody2D
@export var Inventory: Control

func _ready():
	messengers.open.connect(open)
	player.pause_pressed.connect(close)

func open():
	visible = true 

func close():
	messengers.disable.emit()
	visible = false

func _on_pebble_pressed():
	add_item("pebble")

func _on_molotov_pressed():
	add_item("molotov_cocktail")

func add_item(item):
	if item in g.inventory:
		g.inventory[item] += 1
	else:
		g.inventory[item] = 1
	Inventory.add_item(item)


func _on_vial_pressed():
	if player.b_echoes - 20 > 0 and player.b_vials != player.max_b_vials:
		player.b_echoes -= 20
		player.b_echoesChanged.emit()
		player.b_vials += 1
		g.vials += 1
		player.vialsChanged.emit()


func _on_bullets_pressed():
	if player.b_echoes - 20 > 0 and player.bullets != player.maxBullets:
		player.b_echoes -= 20
		player.b_echoesChanged.emit()
		player.bullets += 1
		g.bullets += 1
		player.bulletsChanged.emit()
