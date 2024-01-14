extends Control

@export var messengers: StaticBody2D
@export var player: CharacterBody2D

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
	if item in globalStats.inventory:
		globalStats.inventory[item] += 1
	else:
		globalStats.inventory[item] = 1

