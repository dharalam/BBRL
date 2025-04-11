extends Node

@onready var player = $"../Player"
var ballScene = preload("res://scenes/Ball.tscn")
var activeBalls = 1
var remainingBalls = 3 
var souls = 0

@onready var game: Control = $".."
signal update_balls

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ballDrop():
	activeBalls = activeBalls - 1
	if activeBalls == 0:
		remainingBalls -= 1
		activeBalls = 1
		update_balls.emit()
		print(remainingBalls)
		var instance = ballScene.instantiate()
		game.call_deferred("add_child", instance)
	if remainingBalls == 0:
		pass #TODO: Game over logic
	
