extends Node2D
@onready var label: Label = $Label
var gm

func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")

func _process(delta: float) -> void:
	label.text = "X"+str(gm.souls)
