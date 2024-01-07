extends Control

@export var Inventory: TextureButton
@export var Stats: TextureButton
@export var Settings: TextureButton
@export var player: CharacterBody2D
@export var hud: Node2D

@export var hand_debug: Sprite2D
@export var hand_weapons: Sprite2D
@export var hand_armor: Sprite2D
@export var hand_quick_items: Sprite2D

signal debug
signal weapons
signal armor
signal quickitems

func _ready():
	Inventory.is_press.connect(inventory)
	Stats.is_press.connect(stats)
	Settings.is_press.connect(settings)
	player.pause_pressed.connect(pause)
	debug.connect(fdebug)
	weapons.connect(fweapons)
	armor.connect(farmor)
	quickitems.connect(fquickitems)

func pause():
	if player.paused:
		visible = true
	else:
		visible = false

func fdebug():
	if not hand_debug.visible:
		hide_hand()
		hand_debug.visible = true

func fweapons():
	if not hand_weapons.visible:
		hide_hand()
		hand_weapons.visible = true

func farmor():
	if not hand_armor.visible:
		hide_hand()
		hand_armor.visible = true

func fquickitems():
	if not hand_quick_items.visible:
		hide_hand()
		hand_quick_items.visible = true

func hide_hand():
	hand_debug.visible = false
	hand_weapons.visible = false
	hand_armor.visible = false
	hand_quick_items.visible = false


func inventory():
	print("Inventory")


func stats():
	print("Stats")


func settings():
	print("Settings")
