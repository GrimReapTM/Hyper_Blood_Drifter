extends Control

@export var Inventory: TextureButton
@export var Equipment: TextureButton
@export var Settings: TextureButton
@export var player: CharacterBody2D
@export var hud: Node2D

func _ready():
	Inventory.is_press.connect(inventory)
	Equipment.is_press.connect(equip)
	Settings.is_press.connect(settings)
	player.pause_pressed.connect(pause)

func pause():
	if player.paused:
		hud.visible = false
		visible = true
	else:
		hud.visible = true
		visible = false

func inventory():
	print("Inventory")


func equip():
	print("Equipment")


func settings():
	print("Settings")
