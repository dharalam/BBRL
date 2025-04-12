extends Node

@export var row_container: Node2D
@export var ball_container: Node2D

const BRICKS_PER_REGION = 72
const ROWS_PER_REGION = 12 

@onready var player = $"../Player"
var ballScene = preload("res://scenes/Ball.tscn")
var RowScene = preload("res://scenes/Row.tscn")
var activeBalls = 1
var remainingBalls = 3 
var souls = 0
var ballLevel = 0
var damageArr = [2, 4, 7, 14]
var remainingBricks = BRICKS_PER_REGION
var remainingRows = ROWS_PER_REGION 
var currentLevel = 0 

signal update_balls

func create_row():
	#Move all existing row downs
	var rows_to_manage = row_container.get_children()
	for row in rows_to_manage:
		row.move_down()
		
	#Generate a new row with a certain number (within threshold) of bricks
	var row = RowScene.instantiate()
	row.rowType = currentLevel
	var rc = remainingBricks / remainingRows + randi_range(-2, 2)
	
	if remainingRows == 1:
		rc = remainingBricks 
	elif rc <= 0:
		rc = 1
	elif rc > 12:
		rc = 12 
	
	print("RC: " + str(rc) + "\nRR: " + str(remainingRows) + "\nRB: " + str(remainingBricks) + "\nBPR: " + str(remainingBricks / remainingRows))
	row.rowBricks = rc
	row_container.add_child(row)
	row.position = Vector2(50, 0)  # Set position (relative to row container)
	
	#Update Remaining (then check if were done with this stage
	remainingBricks = remainingBricks - rc 
	remainingRows = remainingRows - 1
	
	if remainingRows == 0:
		remainingRows = ROWS_PER_REGION
		remainingBricks = BRICKS_PER_REGION
		if currentLevel < 2: 
			currentLevel = currentLevel + 1 
		#Also update the background?

func _ready():
	randomize()
	print("RowScene loaded:", RowScene)
	create_row()

func ballDrop():
	activeBalls = activeBalls - 1
	if activeBalls == 0:
		remainingBalls -= 1
		activeBalls = 1
		update_balls.emit()
		print(remainingBalls)
		var instance = ballScene.instantiate()
		ball_container.call_deferred("add_child", instance)
	if remainingBalls == 0:
		pass #TODO: Game over logic
		
func getBallLevel():
	return ballLevel

func increaseBallLevel():
	ballLevel = ballLevel + 1
