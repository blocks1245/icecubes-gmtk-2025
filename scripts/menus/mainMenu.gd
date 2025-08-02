extends Control

@onready var menu: VBoxContainer = $menu # Main menu UI parent node
@onready var credits_vbox: VBoxContainer = $CenterContainer/creditsVbox #vbox container for credits UI
@onready var credits_tab: TabContainer = $CenterContainer/creditsVbox/credits
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

func _ready() -> void:
	music.stopAll() # stops music
	gameManager.running = false # the game is no longer running
	player.update() # update player to not fuck up main menu
	
	music.playMainMenu()
	animation_player.play("FadeIn") # Start animation to fade back in from black
	animation_player_2.play("main menu bob")
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)

func _on_play_game_pressed() -> void: # When the play button is pressed (start the game)
	music.buttonPress()
	gameManager.reset() # Reset game stats, in case the player quit to menu
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	gameManager.running = true # Tell the player that the game is running
	player.update() # Makes the player check the game state, which turns it visible and enables the player camera
	
	#Tells the game manager to choose which rooms will be active this round, then loads the first room as the current scene
	get_tree().change_scene_to_file("res://scenes/rooms/%s" % gameManager.chooseRooms()[0])

func _on_credits_pressed() -> void: # When the credits button is pressed
	music.buttonPress()
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	menu.visible = false # Make main menu UI invisible
	credits_vbox.visible = true # makes credits UI visible
	
	animation_player.play("FadeIn") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)


func _on_quit_game_pressed() -> void: # When the quit button is pressed
	music.buttonPress()
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	get_tree().quit() # Quit the game


func _on_return_pressed() -> void: # When return to menu is pressed
	music.buttonPress()
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	credits_vbox.visible = false # Make credits UI invisible
	menu.visible = true # Make main menu UI visible
	credits_tab.current_tab = 0
	
	animation_player.play("FadeIn") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
