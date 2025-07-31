extends Node2D

@onready var rng = RandomNumberGenerator.new() #creating rng variable
@onready var marker: Label = $Marker #temporary marker while rooms are litteraly empty to show which one it is
@onready var animation_player: AnimationPlayer = $AnimationPlayer #animation player for fading to and from black

var anomaly: bool # does it have anomalies

func _ready():
	if player.right == true:
		player.position.x = $rightExitArea/rightExitAreaCollider.position.x - 200
	else:
		player.position.x = $leftExitArea/leftExitAreaCollider.position.x + 200
		
	_fading_process() #fade in
	_generate_anomaly() #Roll to see if this room is an anomaly
	marker.text = "Room: " + str(self.name) + " | anomaly ?: " + str(anomaly) + " | score: " + str(gameManager.getScore()) #Temp output for anomaly status

func _fading_process():
	animation_player.play("FadeIn")
	await animation_player.animation_finished

func _generate_anomaly():
	if rng.randi_range(0, 100) > 50: #50% chance for anomaly
		anomaly = true
	else:
		anomaly = false

func _on_right_exit_area_area_entered(_area: Area2D) -> void: # if you touch the right side
	await get_tree().physics_frame # waits until the next physics frame because godot keeps yelling at me for going too fast
	
	if player.right == true:
		if anomaly == true:
			gameManager.addScore()
		else:
			gameManager.resetScore()
	else:
		if anomaly == true:
			gameManager.resetScore()
		else:
			gameManager.addScore()
	
	player.right = false
	
	_select_next_room() # select the next room

func _on_left_exit_area_area_entered(_area: Area2D) -> void: # if you touch the left side
	await get_tree().physics_frame # waits until the next physics frame because godot keeps yelling at me for going too fast
	
	if player.right == true:
		if anomaly == true:
			gameManager.resetScore()
		else:
			gameManager.addScore()
	else:
		if anomaly == true:
			gameManager.addScore()
		else:
			gameManager.resetScore()
	
	player.right = true
	
	_select_next_room() # select the next room
	
func _select_next_room():
	animation_player.play("FadeToBlack")
	await animation_player.animation_finished
	
	var room = rng.randi_range(1, gameManager.getRooms())
	print(str(room))
	
	if (str(room) == name):
		room += 1
	
	get_tree().change_scene_to_packed(load("res://scenes/rooms/room%s.tscn" % room))
