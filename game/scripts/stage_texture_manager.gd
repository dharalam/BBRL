extends TextureRect

@onready var gm: Node = %GameManager
@onready var stage1 = preload("res://assets/stage1.png")
@onready var stage2 = preload("res://assets/stage2.png")
@onready var stage3 = preload("res://assets/stage3.png")
var stages


func _ready() -> void:
	stages = [stage1, stage2, stage3]
	texture = stages[gm.currentLevel]
	

func change_stage(level: int):
	texture = stages[level]
