extends Node

@onready var score = 0
@onready var mistakes = 0
@onready var rooms = len(DirAccess.get_files_at("res://scenes/rooms/"))
@onready var running = false

func addScore(): #adds to the current score
	score += 1

func resetScore(): # resets the current score
	score = 0
	mistakes += 1

func getScore(): # returns the score
	return score

func getMistakes():
	return mistakes

func reset():
	score = 0
	mistakes = 0

func getRooms():# returns the number of rooms
	print(rooms)
	return rooms
