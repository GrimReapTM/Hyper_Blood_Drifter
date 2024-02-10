extends Control

@export var pause: Control
@export var shop: Control
@export var inventory: Control
@export var HUD: Node2D

@export var score: Label
@export var highscore: Label
@export var nhighscore: Label

func update():
	pause.visible = false
	shop.visible = false
	inventory.visible = false
	HUD.visible = false
	score.text = "score:" + str(g.score)
	if g.score >= g.highscore:
		g.highscore = g.score
		nhighscore.visible = true
	g.score = 0
	highscore.text = "highscore: " + str(g.highscore)


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/areas/Dream.tscn")
	g.dead = false


func _on_quit_pressed():
	get_tree().quit()
