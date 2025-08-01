extends Control

@onready var menu: VBoxContainer = $CenterContainer/menu # Main menu UI parent node
@onready var credits: VBoxContainer = $CenterContainer/credits # Credits screen UI parent node

func _ready() -> void:
	music.playMainMenu()

func _on_play_game_pressed() -> void: # When the play button is pressed (start the game)
	gameManager.reset() # Reset game stats, in case the player quit to menu
	
	gameManager.running = true # Tell the player that the game is running
	player.update() # Makes the player check the game state, which turns it visible and enables the player camera
	
	#Tells the game manager to choose which rooms will be active this round, then loads the first room as the current scene
	get_tree().change_scene_to_file("res://scenes/rooms/%s" % gameManager.chooseRooms()[0])

func _on_credits_pressed() -> void: # When the credits button is pressed
	menu.visible = false # Make main menu UI invisible
	credits.visible = true # Make credits UI visible


func _on_quit_game_pressed() -> void: # When the quit button is pressed
	get_tree().quit() # Quit the game


func _on_return_pressed() -> void: # When return to menu is pressed
	credits.visible = false # Make credits UI invisible
	menu.visible = true # Make main menu UI visible
