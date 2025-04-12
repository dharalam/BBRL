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
var ballLevel = 0

var currentLevel = 0 
var souls = 0

var damageArr = [2, 4, 7, 14]
var chanceArr = [-10, 5, 8] #Shop, Bomb, Charge 

var remainingBricks = BRICKS_PER_REGION
var remainingRows = ROWS_PER_REGION 

signal update_balls
signal game_over

func create_row():
	#Move all existing row downs
	var rows_to_manage = row_container.get_children()
	for row in rows_to_manage:
		row.move_down()
		
	#Generate a new row, set the number of bricks to be some amount
	var row = RowScene.instantiate()
	row.rowType = currentLevel
	var rc = round(float(remainingBricks) / remainingRows) + randi_range(-2, 2)
	
	#if on the last row set it to the number of remaing
	#otherwise check that the amount of bricks were spawning is within bounds
	if remainingRows == 1:
		rc = remainingBricks 
	elif rc <= 0:
		rc = 1
	elif rc > 12:
		rc = 12 
	
	#Check if a shop spawn, if not increase odds on next row 
	var rand := randi() % 100
	if rand < chanceArr[0]:
		row.shopRow = true
		chanceArr[0] = -10 #negative odds prevent back to back shop spawns
	else:
		chanceArr[0] = chanceArr[0] + 15 
		
	#Set the chance of bombs/charges, and the number of bricks in the row
	row.bombChance = chanceArr[1] 
	row.chargeChance = chanceArr[2]
	row.rowBricks = rc
	row_container.add_child(row)
	row.position = Vector2(50, 0)  # Set position (relative to row container)
	
	#Update Remaining bricks/rows
	remainingBricks = remainingBricks - rc 
	remainingRows = remainingRows - 1
	
	if remainingRows == 0:
		#if you hit the end of a region without seeing a shop in the last 5 rows you guarentee get one
		if chanceArr[0] >= 50:
			chanceArr[0] = 100 
		remainingRows = ROWS_PER_REGION
		remainingBricks = BRICKS_PER_REGION
		if currentLevel < 2: 
			currentLevel = currentLevel + 1 
		#Also update the background?

func _ready():
	randomize()
	create_row()

func ballDrop():
	activeBalls = activeBalls - 1
	if activeBalls == 0:
		if remainingBalls == 0:
			game_over.emit()
			return
		else:
			remainingBalls -= 1
			activeBalls = 1
			update_balls.emit()
			print(remainingBalls)
			var instance = ballScene.instantiate()
			ball_container.call_deferred("add_child", instance)
		
		
func getBallLevel():
	return ballLevel

func increaseBallLevel():
	ballLevel = ballLevel + 1

func increaseBombChance():
	chanceArr[1] = chanceArr[1] + 2

func increaseChargeChance():
	chanceArr[2] = chanceArr[2] + 3 
