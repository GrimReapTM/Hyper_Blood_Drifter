extends Control
@export var Inventory: Control
@export var Status: Control
@export var System: Control

@export var player: CharacterBody2D
@export var hud: Node2D
@export var Item_name: Label
@export var Item_sprite: Sprite2D
@export var Item_amount: Label

@export var hand_debug: Sprite2D
@export var hand_weapons: Sprite2D
@export var hand_armor: Sprite2D
@export var hand_quick_items: Sprite2D

@export var label_debug: Label
@export var label_weapons: Label
@export var label_armor: Label
@export var label_quick: Label

@export var Q1Sprite: Sprite2D
@export var Q2Sprite: Sprite2D
@export var Q3Sprite: Sprite2D
@export var Q4Sprite: Sprite2D
@export var Q5Sprite: Sprite2D
@export var Q6Sprite: Sprite2D
var sprites = []



@export var a_open: AudioStreamPlayer
@export var a_close: AudioStreamPlayer
@export var a_move: AudioStreamPlayer

signal debug
signal weapons
signal armor
signal quickitems

'''
molotov_cocktail - 1
pebble - 2
throwing_knife - 3
beast_pellet - 4
hunter's mark - 5
bolt_paper - 6
coldblood_dew - 7
fire_paper - 8
lantern - 9
iosefka_blood - 10
madmans_knowledge - 11
umbilical_cord - 12
'''


func _ready():
	sprites = [Q1Sprite, Q2Sprite, Q3Sprite, Q4Sprite, Q5Sprite, Q6Sprite]
	g.itemAmount.connect(change_amount)
	g.showHud.connect(show_hud)
	g.nullSprite.connect(null_sprite)
	g.changeSprite.connect(change_sprite)
	g.changeSprite.connect(disable_buttons)
	g.equiped_null.connect(equiped_null)
	player.pause_pressed.connect(pause)
	if g.equiped_slot != null:
		check_quick(g.quick_slots[g.slot])


func show_hud():
	hud.visible = true

func pause():
	if not visible and not player.paused:
		player.paused = true
		visible = true
		a_open.play()
	else:
		player.paused = false
		visible = false
		a_close.play()


func _input(event):
	if event.is_action_pressed("Q1"):
			check_quick(g.quick_slots[0])
			g.slot = 0
	elif event.is_action_pressed("Q2"):
			check_quick(g.quick_slots[1])
			g.slot = 1
	elif event.is_action_pressed("Q3"):
			check_quick(g.quick_slots[2])
			g.slot = 2
	elif event.is_action_pressed("Q4"):
			check_quick(g.quick_slots[3])
			g.slot = 3
	elif event.is_action_pressed("Q5"):
			check_quick(g.quick_slots[4])
			g.slot = 4
	elif event.is_action_pressed("Q6"):
			check_quick(g.quick_slots[5])
			g.slot = 5


func check_quick(slot):
	if slot != null:
		g.equiped_slot = slot
		match slot:
			"molotov_cocktail":
				change_quick("Molotov Cocktail", 1)
			"pebble":
				change_quick("Pebble", 2)
			"throwing_knife":
				change_quick("Throwing Knife", 3)
			"beast_pellet":
				change_quick("Beast Blood Pellet", 4)
			"hunters_mark":
				change_quick("Bold Hunter's Mark", 5)
			"bolt_paper":
				change_quick("Bolt Paper", 6)
			"coldblood_dew":
				change_quick("Coldblood Dew", 7)
			"fire_paper":
				change_quick("Fire Paper", 8)
			"lantern":
				change_quick("Lantern", 9)
			"iosefka_blood":
				change_quick("Iosefka's Blood", 10)
			"madmans_knowledge":
				change_quick("Madman's Knowledge", 11)
			"umbilical_cord":
				change_quick("One Third of Umbilical Cord", 12)

func change_quick(label, frame):
	Item_name.text = label
	Item_sprite.frame = frame
	if g.inventory[g.equiped_slot] != null:
		Item_amount.text = str(g.inventory[g.equiped_slot])

func change_amount():
	if g.equiped_slot != null:
		Item_amount.text = str(g.inventory[g.equiped_slot])
	else:
		Item_amount.text = ""

func equiped_null():
		Item_name.text = ""
		Item_sprite.frame = 0

#--------------------------------------------------------------------------
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

#debug
func _on_inventory_button_mouse_entered():
	a_move.play()
	fdebug()
	label_debug.text = "Inventory"

func _on_stats_button_mouse_entered():
	a_move.play()
	fdebug()
	label_debug.text = "Status"

func _on_settings_button_mouse_entered():
	a_move.play()
	fdebug()
	label_debug.text = "System"

#weapons
func _on_r_1_mouse_entered():
	a_move.play()
	fweapons()
	label_weapons.text = "Right Hand"

func _on_r_2_mouse_entered():
	a_move.play()
	fweapons()
	label_weapons.text = "Right Hand"

func _on_l_1_mouse_entered():
	a_move.play()
	fweapons()
	label_weapons.text = "Left Hand"

func _on_l_2_mouse_entered():
	a_move.play()
	fweapons()
	label_weapons.text = "Left Hand"


#armor
func _on_head_mouse_entered():
	a_move.play()
	farmor()
	label_armor.text = "Head"

func _on_shoulders_mouse_entered():
	a_move.play()
	farmor()
	label_armor.text = "Torso"

func _on_knees_mouse_entered():
	a_move.play()
	farmor()
	label_armor.text = "Arms"

func _on_toes_mouse_entered():
	a_move.play()
	farmor()
	label_armor.text = "Boots"

#quickslots
func _on_q_1_mouse_entered():
	a_move.play()
	fquickitems()
	label_quick.text = label_quick_check(0)

func _on_q_2_mouse_entered():
	a_move.play()
	fquickitems()
	label_quick.text = label_quick_check(1)

func _on_q_3_mouse_entered():
	a_move.play()
	fquickitems()
	label_quick.text = label_quick_check(2)

func _on_q_4_mouse_entered():
	a_move.play()
	fquickitems()
	label_quick.text = label_quick_check(3)

func _on_q_5_mouse_entered():
	a_move.play()
	fquickitems()
	label_quick.text = label_quick_check(4)

func _on_q_6_mouse_entered():
	a_move.play()
	fquickitems()
	label_quick.text = label_quick_check(5)

func label_quick_check(slot):
	if g.quick_slots[slot] != null:
		return g.get_item(slot, "name")
	else:
		return "Quick Items"

func _on_q_1_pressed():
	a_open.play()
	add_quick(0)

func _on_q_2_pressed():
	a_open.play()
	add_quick(1)

func _on_q_3_pressed():
	a_open.play()
	add_quick(2)

func _on_q_4_pressed():
	a_open.play()
	add_quick(3)

func _on_q_5_pressed():
	a_open.play()
	add_quick(4)

func _on_q_6_pressed():
	a_open.play()
	add_quick(5)
#-----------------------------------------------------------------

func add_quick(slot):
	if Inventory.is_inventory_empty_by_any_chance():
		player.paused = true
		var j = 0
		for i in Inventory.child_inventory:
			if is_instance_valid(i):
				i.button.disabled = false
			else:
				Inventory.child_inventory.remove_at(j)
				add_quick(slot)
			j += 1
		visible = false
		Inventory.InvQuick.text = "Quick Items - " + str(slot)
		Inventory.update()
		Inventory.visible = true
		hud.visible = false
		g.next_slot = slot

func disable_buttons():
		for i in Inventory.child_inventory:
			if is_instance_valid(i):
				i.button.disabled = true
			else:
				Inventory.child_inventory.remove_at(i)
		visible = true
		Inventory.visible = false

func change_sprite():
	if g.old_slot != null:
		sprites[g.old_slot].frame = 0
		g.old_slot = null
	sprites[g.next_slot].frame = g.item_ids[g.quick_slots[g.next_slot]]

func null_sprite():
	sprites[g.slot].frame = 0




func _on_inventory_button_pressed():
	a_open.play()
	visible = false
	Inventory.InvQuick.text = "Inventory"
	Inventory.update()
	Inventory.visible = true
	player.HUD.visible = false


func _on_stats_button_pressed():
	a_open.play()
	visible = false
	Status.visible = true
	player.HUD.visible = false

func _on_settings_button_pressed():
	a_open.play()
	visible = false
	System.visible = true
	player.HUD.visible = false
