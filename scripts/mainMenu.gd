extends Control

@onready var menu: VBoxContainer = $menu # Main menu UI parent node
@onready var credits_vbox: VBoxContainer = $CenterContainer/creditsVbox # Vbox container for credits UI
@onready var credits_tab: TabContainer = $CenterContainer/creditsVbox/credits # Credits tab
@onready var animation_player: AnimationPlayer = $AnimationPlayer # Animation player for fading
@onready var fake_player: AnimatedSprite2D = $background/fakePlayer

func _ready() -> void:
	music.stopAll() # Stops music
	gameManager.running = false # Unrender map and player
	player.update()
	map.update(null)
	
	music.playMainMenu() # Play menu music
	
	animation_player.play("FadeIn") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)

func _on_play_game_pressed() -> void: # When the play button is pressed (start the game)
	music.buttonPress() # Play button press sound
	gameManager.reset() # Reset game stats, in case the player quit to menu
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	gameManager.running = true # Tell the player that the game is running
	player.update() # Makes the player check the game state, which turns it visible and enables the player camera
	# Map doesn't need to update because it can never render right now anyways
	
	#Tells the game manager to choose which rooms will be active this round, then loads the first room as the current scene
	get_tree().change_scene_to_file("res://scenes/%s" % gameManager.chooseRooms()[0])

func _on_credits_pressed() -> void: # When the credits button is pressed
	music.buttonPress() # Play button press sfx
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	menu.visible = false # Make main menu UI invisible
	credits_vbox.visible = true # makes credits UI visible
	
	animation_player.play("FadeIn") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)


func _on_quit_game_pressed() -> void: # When the quit button is pressed
	music.buttonPress() # Play button press sound
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	get_tree().quit() # Quit the game


func _on_return_pressed() -> void: # When return to menu is pressed
	music.buttonPress() # Play button press sound (why can you not automate this through themes my god)
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	credits_vbox.visible = false # Make credits UI invisible
	menu.visible = true # Make main menu UI visible
	credits_tab.current_tab = 0 # Reset credits tab
	
	animation_player.play("FadeIn") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)


func _on_credits_tab_changed(_tab: int) -> void: 
	music.buttonPress() # You guessed it; play the button press sfx!!
