extends Control

@onready var menu: VBoxContainer = $CenterContainer/menu # main menu UI parent node
@onready var credits: VBoxContainer = $CenterContainer/credits # credits UI parent node

var game = load("res://scenes/rooms/room1.tscn") # gets room 1 from filepath

func _on_play_game_pressed() -> void:	
	gameManager.running = true # game is running
	player.is_game_running() # makes player visible again
	get_tree().change_scene_to_packed(game) # changes level to first room


func _on_credits_pressed() -> void: # shows credits
	menu.visible = false # makes menu UI invisible
	credits.visible = true # makes credits UI visible


func _on_quit_game_pressed() -> void:
	get_tree().quit() # quits the game when quit button is pressed


func _on_return_pressed() -> void: # shows main menu again
	credits.visible = false # makes credits UI invisible
	menu.visible = true # makes main menu UI visible 
