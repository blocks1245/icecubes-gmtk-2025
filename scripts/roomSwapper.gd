extends Node2D

## PLEASE DO NOTE, BATHROOM IS THE PARENT OF ALL ROOMS, ALL CHANGES MADE ON BATHROOM WILL AFFECT ALL ROOMS, BUT CHANGES ON OTHER ROOMS WILL NOT AFAIK

@onready var floor_collision: CollisionPolygon2D = $floor/floorCollision #get floor collision
@onready var floor_polygon: Polygon2D = $floor/floorCollision/floorPolygon#get floor polygon
@onready var rng = RandomNumberGenerator.new() #creating rng variable
@onready var marker: Label = $Marker #temporary marker while rooms are litteraly empty to show which one it is
@onready var animation_player: AnimationPlayer = $AnimationPlayer #animation player for fading to and from black

var bathroom = load("res://scenes/rooms/bathroom.tscn") # gets all the 4 rooms
var bedroom = load("res://scenes/rooms/bedroom.tscn") #im sorry for this, but packed scenes gave me a parse error
var kitchen = load("res://scenes/rooms/kitchen.tscn")
var livingroom = load("res://scenes/rooms/livingroom.tscn")

var isAnomalied: bool # does it have anomalies, TBD make this have purpose

func _ready() -> void:
	_fading_process()
	floor_polygon.polygon = floor_collision.polygon #Quick dirty polygon so you can see the floor, will be replaced ofc
	_generate_anomaly() # does randomness to determine wether it will be a room with anomalies
	marker.text = "Room: " + str(self.name) + " 
	isAnomalied ?: " + str(isAnomalied) # telling marker to give me information
	
func _fading_process():
	get_tree().paused = true
	animation_player.play("FadeToWhite")
	await animation_player.animation_finished
	get_tree().paused = false


func _generate_anomaly():
	if rng.randi_range(1, 2) == 1: #generates random ineteger between 0 and 1, 0 , means anomaly, otherwise, make it not an anomaly
		isAnomalied = true
	else:
		isAnomalied = false

func _on_right_exit_area_area_entered(_area: Area2D) -> void: # if you touch the right side
	await get_tree().physics_frame # waits until the next physics frame because godot keeps yelling at me for going too fast
	_select_next_room() # select the next room


func _on_left_exit_area_area_entered(_area: Area2D) -> void: # if you touch the left side
	await get_tree().physics_frame # waits until the next physics frame because godot keeps yelling at me for going too fast
	_select_next_room() # select the next room
	
func _select_next_room(): #this whole function makes me want to cry
	if rng.randi_range(1, 4) == 1: # runs a 1 in 4 chance that the living room gets chosen
		if name == "livingroom": # this is so horrid but i tried everything
			if !get_tree(): return #im sorry i had to repeat this so often, it just doesnt work if i dont do it like this
			get_tree().change_scene_to_packed(kitchen)
		if !get_tree(): return
		get_tree().change_scene_to_packed(livingroom)
	elif rng.randi_range(1, 3) == 1: # runs a 1 in 3 chance that kitchen gets chosen
		if name == "kitchen":
			if !get_tree(): return
			get_tree().change_scene_to_packed(bathroom)
		if !get_tree(): return
		get_tree().change_scene_to_packed(kitchen)
	elif rng.randi_range(1, 2) == 1: # runs a 1 in 2 that the bathroom gets chosen
		if name == "bathroom":
			if !get_tree(): return
			get_tree().change_scene_to_packed(bedroom)
		if !get_tree(): return
		get_tree().change_scene_to_packed(bathroom)
	else: #all else fails, take the bedroom
		if name == "bedroom":
			if !get_tree(): return
			get_tree().change_scene_to_packed(livingroom)
		if !get_tree(): return
		get_tree().change_scene_to_packed(bedroom)
