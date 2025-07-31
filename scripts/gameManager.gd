extends Node

@onready var score = 0
@onready var rooms = 3

func addScore():
	score += 1

func resetScore():
	score = 0

func getScore():
	return score

func getRooms():
	return rooms
