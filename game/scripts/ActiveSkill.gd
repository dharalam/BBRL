extends Node2D
var gm
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
var no_power # load("res://assets/filename.png")
var multiball
var freeze
var speedup
var lightning
var icons = [no_power, multiball, freeze, speedup, lightning]

func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")

func change_power(index: int):
	texture_progress_bar.texture_progress = icons[index]
	texture_progress_bar.tint_under = Color(0.19, 0.19, 0.19, 1.0)
	texture_progress_bar.texture_under = icons[index]

func _process(delta: float) -> void:
	texture_progress_bar.value = min(gm.active_cd * gm.cd_reduction, gm.tsa)
