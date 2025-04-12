extends VBoxContainer
@onready var game_manager: Node = %GameManager
var timer_scene = preload("res://scenes/GameTimer.tscn")
var block_bar = preload("res://scenes/BlockBar.tscn")
var items = [timer_scene, block_bar]
var item_refs = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in items:
		$".".size.y += 128
		var divider = HBoxContainer.new()
		divider.set_size(Vector2(128, 128))
		divider.alignment = BoxContainer.ALIGNMENT_CENTER
		add_child(divider)
		var child = item.instantiate()
		item_refs.append(child)
		divider.add_child(child)
		add_spacer(false)
	var timer = item_refs[0].get_child(0)
	var progbar = item_refs[1].get_child(0)
	timer.timeout.connect(progbar.cycle_completed)
	progbar.full.connect(game_manager.create_row)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
