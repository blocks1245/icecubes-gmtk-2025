extends Node2D

@onready var rng = RandomNumberGenerator.new() #creating rng variable
@onready var marker: Label = $Marker #temporary marker while rooms are litteraly empty to show which one it is
@onready var animation_player: AnimationPlayer = $AnimationPlayer #animation player for fading to and from black

var anomaly: bool # does it have anomalies

func _ready():
	if player.right == true: # offsets the player to be closer to the door they went in from
		player.position.x = $rightExitArea/rightExitAreaCollider.position.x - 200 #if the player was on the right, they go towards the left door
	else:
		player.position.x = $leftExitArea/leftExitAreaCollider.position.x + 200 #if they where on the left, they go towards the right door
		
	_fading_process() #fade in
	_generate_anomaly() #Roll to see if this room is an anomaly
	marker.text = "Room: " + str(self.name) + " | anomaly ?: " + str(anomaly) + " | score: " + str(gameManager.getScore()) #Temp output for anomaly status

func _fading_process():
	get_tree().paused = true
	animation_player.play("FadeIn") #start animation
	await animation_player.animation_finished #wait till its done to continue
	get_tree().paused = false

func _generate_anomaly():
	if rng.randi_range(0, 100) > 50: #50% chance for anomaly
		anomaly = true #the 0-100 feels so wack but oh well, works aswell lol
	else:
		anomaly = false

func _on_right_exit_area_area_entered(_area: Area2D) -> void: # if you touch the right side
	await get_tree().physics_frame # waits until the next physics frame because godot keeps yelling at me for going too fast
	
	player.right = true # the player is currently on the right side
	_check_direction() # checks if the player made the right choice
	player.right = false # player will be put on the left side in the next room
	
	_select_next_room() # select the next room

func _on_left_exit_area_area_entered(_area: Area2D) -> void: # if you touch the left side
	await get_tree().physics_frame # waits until the next physics frame because godot keeps yelling at me for going too fast
	
	player.right = false # the player is currently on the left side
	_check_direction() # checks if the player made the right choice
	player.right = true # the player will be on the right side in the next room
	
	_select_next_room() # select the next room
	
func _check_direction():
	if player.right == true:
		if anomaly == true: #if the player went to the right and there was an anomaly, reset the score (wrong)
			gameManager.resetScore()
		else: # if they went to the right and had an anomaly, add to the score (correct)
			gameManager.addScore()
	else:
		if anomaly == true: # if they went left and there was an anomaly, add to the score (correct)
			gameManager.addScore()
		else:
			gameManager.resetScore() # if they went left and there was no anomaly, reset the score (wrong)

func _select_next_room():
	get_tree().paused = true
	animation_player.play("FadeToBlack") # start animation
	await animation_player.animation_finished # do not continue process until the animation is finished
	get_tree().paused = false
	
	var room = rng.randi_range(1, gameManager.getRooms()) # select the next room randomly
	print(str(room))
	
	if (str(room) == name): # this is done to avoid duplicates
		if room >= gameManager.getRooms(): #checks that we arent trying to call a non existant room
			room -= 1 # substract one to avoid duplicate and not get non existant room 
		else: # we arent surpassing the number of rooms we have
			room += 1 # add one to avoid duplicates
	
	get_tree().change_scene_to_packed(load("res://scenes/rooms/room%s.tscn" % room)) # change scene to the selected room
	
