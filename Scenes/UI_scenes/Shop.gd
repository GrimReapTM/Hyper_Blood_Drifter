extends Control

const item = preload("res://Scenes/UI_scenes/inventory_item.tscn")

@export var messengers: StaticBody2D
@export var player: CharacterBody2D
@export var Inventory: Control
@export var container: VBoxContainer
@export var HUD: Node2D

func _ready():
	messengers.open.connect(open)
	player.pause_pressed.connect(close)
	g.addItem.connect(add_item)
	
	var instance
	for i in g.item_ids:
		instance = item.instantiate()
		instance.type = "shop"
		instance.ID = i
		container.add_child(instance)

func open():
	visible = true
	HUD.visible = false
	g.openShop.emit()

func close():
	HUD.visible = true
	messengers.disable.emit()
	visible = false


func add_item():
	Inventory.add_item(g.next_item)


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
