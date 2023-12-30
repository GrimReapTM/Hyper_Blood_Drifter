extends Control

@export var Inventory: TextureButton
@export var Equipment: TextureButton
@export var Settings: TextureButton

func _ready():
	Inventory.is_press.connect(inventory)
	Equipment.is_press.connect(equip)
	Settings.is_press.connect(settings)
	

func inventory():
	print("Inventory")


func equip():
	print("Equipment")


func settings():
	print("Settings")
