extends Control

const item = preload("res://Scenes/UI_scenes/inventory_item.tscn")

@export var messengers: StaticBody2D
@export var player: CharacterBody2D
@export var Inventory: Control
@export var container: VBoxContainer
@export var HUD: Node2D

@export var a_open: AudioStreamPlayer
@export var a_close: AudioStreamPlayer

@export var Lv: Label
@export var Be: Label
@export var In: Label
@export var Vit: Label
@export var End: Label
@export var Str: Label
@export var Bld: Label

func update():
	Lv.text = str(g.Level)
	Be.text = str(g.b_echoes)
	In.text = str(g.insight)
	Vit.text = str(g.Vitality)
	End.text = str(g.Endurance)
	Str.text = str(g.Strength)
	Bld.text = str(g.Bloodtinge)


func _ready():
	g.beChanged.connect(update)
	g.iChanged.connect(update)
	if messengers != null:
		messengers.open.connect(update)
		messengers.open.connect(open)
	player.pause_pressed.connect(close)
	g.addItem.connect(add_item)
	
	var instance
	
	var vb = ["vial", "bullet"]
	for i in vb:
		instance = item.instantiate()
		instance.type = "shop"
		instance.ID = i
		if i == "vial":
			instance.vial = true
		else:
			instance.bullet = true
		container.add_child(instance)
	
	for i in g.item_ids:
		instance = item.instantiate()
		instance.type = "shop"
		instance.ID = i
		container.add_child(instance)

func open():
	a_open.play()
	visible = true
	HUD.visible = false
	g.openShop.emit()

func close():
	a_close.play()
	HUD.visible = true
	messengers.disable.emit()
	visible = false


func add_item():
	Inventory.add_item(g.next_item)
