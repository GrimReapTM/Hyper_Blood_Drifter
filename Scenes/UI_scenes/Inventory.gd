extends Control

const Item = preload("res://Scenes/UI_scenes/inventory_item.tscn")
@export var container: Control
@export var player: CharacterBody2D
@export var Paused: Control

@export var a_close: AudioStreamPlayer

var inventory = []
var child_inventory = []

func _ready():
	player.pause_pressed.connect(close)
	if is_inventory_empty_by_any_chance():
		for i in g.inventory:
			var instance = Item.instantiate()
			instance.ID = i
			instance.item()
			child_inventory.append(instance)
			container.add_child(instance)

func is_inventory_empty_by_any_chance():
	for i in g.inventory:
		if i in g.inventory:
			return true
		else:
			return false

func add_item(item):
	for i in child_inventory:
		if is_instance_valid(i) and i.ID == item:
			g.itemAmount.emit()
			var child = []
			for j in container.get_children():
				child.append(j.ID)
			return
	var instance = Item.instantiate()
	instance.ID = item
	container.add_child(instance)
	inventory.append(item)
	child_inventory.append(instance)

func close():
	if visible:
		a_close.play()
		visible = false
		Paused.visible = true
		player.HUD.visible = true
		player.paused = true
