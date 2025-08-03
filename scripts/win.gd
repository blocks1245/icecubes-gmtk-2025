extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# No cutscene yet
	gameManager.running = false # Unrender map and player
	player.update()
	map.update(null)
	
	gameManager.vignetteMultiplier = 10 # Make the vignette basically neglibile
	gameManager.vignetteSoftness = 10
		
	vignette.edit(gameManager.vignetteMultiplier, gameManager.vignetteSoftness) # Apply changes
	
	music.fadeOut(music.regular, 2) # Fade out the music and buzzing
	music.fadeOut(music.buzzing, 5)
	
	music.playBirds() # Fade in bird sounds :3
	music.fadeIn(music.birds, 5)
	
	animation_player.play("FadeIn") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)

func _on_try_again_pressed() -> void:
	music.stopBirds() # No more birds 3:
	
	music.fadeIn(music.regular, 1) # Fade in music and buzzing fast
	music.fadeIn(music.buzzing, 1)

	music.buttonPress() # Play button press sounds
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	gameManager.reset() # Reset round variables
	gameManager.running = true # Set game to running
	
	# Reload at what is now room 0 (should be tutorial 1)
	get_tree().change_scene_to_file("res://scenes/%s" % gameManager.chooseRooms()[0])

func _on_main_menu_pressed() -> void:
	music.stopBirds() # No birds for quitters >:(
	
	music.fadeIn(music.regular, 1) # Fade in music and buzzing
	music.fadeIn(music.buzzing, 1)
	
	music.buttonPress() # Play button press sfx
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	get_tree().change_scene_to_file("res://scenes/ui/mainMenu.tscn") # Swap to main menu scene
