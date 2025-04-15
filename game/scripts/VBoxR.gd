extends VBoxContainer
@onready var game_manager: Node = %GameManager
@onready var game_timer: Node2D = $GameTimer
@onready var block_bar: Node2D = $BlockBar
@onready var souls_ui: Node2D = $SoulsUI
@onready var active_skill_bar: Node2D = $ActiveSkillBar

var hourglass 
var ice 
var timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var progbar = block_bar.get_node("TextureProgressBar")
	timer = game_timer.get_node("Timer")
	hourglass = game_timer.get_node("Hourglass")
	ice = game_timer.get_node("Ice")
	timer.timeout.connect(progbar.cycle_completed)
	progbar.full.connect(game_manager.create_row)
	
func pause_timer():
	hourglass.pause()
	ice.visible = true 
	timer.paused = true 

func resume_timer():
	hourglass.play()
	ice.visible = false
	timer.paused = false
	
	
