extends Node


var melee_damage = 22
var ranged_damage = 4

var inventory = {"molotov_cocktail":1, "pebble":2, "throwing_knife":3, "beast_pellet":4, "hunters_mark":5, "bolt_paper":6, "coldblood_dew":7, "fire_paper":8, "lantern":9, "iosefka_blood":10, "madmans_knowledge":11, "umbilical_cord":12}
var quick_slots = [null, null, null, null, null, null]
var equiped_slot = 0
var next_slot = 0
var old_slot = null

signal inventoryChanged
signal itemAmount
signal changeSprite


var item_ids = {"molotov_cocktail":1, "pebble":2, "throwing_knife":3, "beast_pellet":4, "hunters_mark":5, "bolt_paper":6, "coldblood_dew":7, "fire_paper":8, "lantern":9, "iosefka_blood":10, "madmans_knowledge":11, "umbilical_cord":12}
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
