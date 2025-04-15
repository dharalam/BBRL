extends CanvasLayer
@onready var gm: Node = %GameManager
@onready var shop: Shop = $"../Shop"
@onready var stats_upgrades: Button = $PanelContainer/MarginContainer/VBoxContainer/StatsSettings/StatsUpgrades
@onready var settings: Button = $PanelContainer/MarginContainer/VBoxContainer/StatsSettings/Settings
@onready var fill_box: VBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Fill Box"
@onready var resume: Button = $PanelContainer/MarginContainer/VBoxContainer/ResumeQuit/Resume
@onready var quit_game: Button = $PanelContainer/MarginContainer/VBoxContainer/ResumeQuit/QuitGame

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if not visible:
		if event.is_action("Pause"):
			get_tree().paused = true
			free_fill_box()
			build_stats_upgrades()
			show()
		
func free_fill_box():
	for node in fill_box.get_children():
		fill_box.remove_child(node)
		node.queue_free()

func build_stats_upgrades():
	fill_box.add_spacer(false)
	var upgrades = shop.upgrades
	var tiers = shop.tiers
	var upgrade_names = shop.upgrade_names
	var power_names = shop.power_names
	for upgrade in upgrades.keys():
		var upgrade_name = Label.new()
		upgrade_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		upgrade_name.text = upgrade_names[upgrade] + " Lvl: " + str(upgrades[upgrade]) + "/" + str(len(tiers[upgrade])-1)
		fill_box.add_child(upgrade_name)
	var power_label = Label.new()
	power_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	power_label.text = power_names[gm.current_power] + ": (cd=" + str(gm.active_cd * gm.cd_reduction) + "sec)"
	fill_box.add_child(power_label)

func build_settings():
	pass # add in some managing logic, ideally for game volume and sound effects.

func _on_stats_upgrades_pressed() -> void:
	free_fill_box()
	build_stats_upgrades()

func _on_settings_pressed() -> void:
	free_fill_box()
	build_settings()

func _on_resume_pressed() -> void:
	$".".hide()
	get_tree().paused = false

func _on_quit_game_pressed() -> void:
	get_tree().quit()
