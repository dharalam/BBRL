extends Node2D
var gm
enum powers {NONE, MULTIBALL, FREEZE, SPEEDUP, LIGHTNING}
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var power_icons = preload("res://assets/powers.png")

var power_atlas = AtlasTexture.new()
var cur_region = 0

var regions = {
	powers.NONE: Rect2(0, 0, 32, 32),
	powers.MULTIBALL: Rect2(32, 0, 32, 32),
	powers.FREEZE: Rect2(64, 0, 32, 32),
	powers.SPEEDUP: Rect2(96, 0, 32, 32),
	powers.LIGHTNING: Rect2(128, 0, 32, 32)
}

func _ready() -> void:
	power_atlas.atlas = power_icons
	power_atlas.region = regions[powers.NONE]
	texture_progress_bar.texture_progress = power_atlas
	texture_progress_bar.tint_under = Color(0.19, 0.19, 0.19, 1.0)
	texture_progress_bar.texture_under = power_atlas

func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")

func change_power(index: int):
	if cur_region == 0:
		gm.tsa = 0
	cur_region = index
	power_atlas.region = regions[index]
	texture_progress_bar.texture_progress = power_atlas
	texture_progress_bar.texture_under = power_atlas
	gm.set_power(index)
	texture_progress_bar.max_value = (gm.active_cd * gm.cd_reduction)

func _process(delta: float) -> void:
	if cur_region != powers.NONE:
		texture_progress_bar.value = min(gm.active_cd * gm.cd_reduction, gm.tsa)
	else:
		texture_progress_bar.value = texture_progress_bar.max_value
