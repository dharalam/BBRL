extends CanvasLayer
class_name Shop

var gm
enum refreshables {BSPEED, PSPEED, BSIZE, PSIZE, BOMB, CHARGE, CYCLES, ACTIVE}
@onready var ball_damage_button: Button = $PanelContainer/MarginContainer/VBoxContainer/PermanentUpgrades/BallDamageButton
@onready var rand_upgrade_1: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Refreshables/VBoxContainer/randUpgrade1
@onready var rand_upgrade_2: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Refreshables/VBoxContainer/randUpgrade2
@onready var rand_upgrade_3: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Refreshables/VBoxContainer/randUpgrade3
@onready var rand_active_skill: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Refreshables/VBoxContainer/randActiveSkill
@onready var rand_upgrade_panels = [rand_upgrade_1, rand_upgrade_2, rand_upgrade_3]
@onready var refresh_button: Button = $"PanelContainer/MarginContainer/VBoxContainer/Refreshables/Refresh Tab/RefreshButton"

var num_refresh = 0
var populated = false
var rand3

var names = {
	-1: "Ball Damage", #ball damage
	refreshables.BSPEED: "Ball Speed",
	refreshables.PSPEED: "Paddle Speed",
	refreshables.BSIZE: "Ball Size",
	refreshables.PSIZE: "Paddle Size",
	refreshables.BOMB: "Bomb Spawn Rate",
	refreshables.CHARGE: "Charge Canister Spawn Rate",
	refreshables.CYCLES: "Cycles Per Row Drop",
	refreshables.ACTIVE: "Active Skill Charge Time"
}

var costs_and_tiers = {
	-1: {1: 5, 2: 10, 3: 15}, #ball damage
	refreshables.BSPEED: {1: 3, 2: 5, 3: 7},
	refreshables.PSPEED: {1: 5, 2: 7, 3: 9},
	refreshables.BSIZE: {1: 4, 2: 6, 3: 8},
	refreshables.PSIZE: {1: 4, 2: 7, 3: 10},
	refreshables.BOMB: {1: 3, 2: 4, 3: 5, 4: 6, 5: 7},
	refreshables.CHARGE: {1: 3, 2: 6, 3: 9},
	refreshables.CYCLES: {1: 10, 2: 15},
	refreshables.ACTIVE: {1: 5, 2: 10, 3: 15}
}

var upgrades = {
	-1: 0, #ball damage
	refreshables.BSPEED: 0,
	refreshables.PSPEED: 0,
	refreshables.BSIZE: 0,
	refreshables.PSIZE: 0,
	refreshables.BOMB: 0,
	refreshables.CHARGE: 0,
	refreshables.CYCLES: 0,
	refreshables.ACTIVE: 0
}

func _ready() -> void:
	$".".hide()

func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")

func get_available_upgrades() -> Array:
	var retarr = []
	for item in upgrades.keys():
		if upgrades[item] < costs_and_tiers[item].size():
			retarr.append(item)
	return retarr
	
func sample_without_replacement(items, num_samples):
	var shuffled_items = items.duplicate() # Create a copy to avoid modifying the original
	shuffled_items.shuffle()
	var samples = []
	for i in range(num_samples):
		if shuffled_items.size() > 0:
			samples.append(shuffled_items.pop_back()) # Remove and return the last element
		else:
			break # Stop if array becomes empty
	return samples

func refresh_shop() -> void:
	var available_upgrades = get_available_upgrades()
	ball_damage_button.text = "Buy: " + str(costs_and_tiers[-1][(upgrades[-1])+1])
	refresh_button.text = "Buy: " + str((2**num_refresh)+1)
	rand3 = sample_without_replacement(available_upgrades, 3)
	for i in range(rand_upgrade_panels.size()):
		var upgrade = rand3[i]
		var name = rand_upgrade_panels[i].get_node("randUpgradeName")
		name.text = names[upgrade]
		var buy_button = rand_upgrade_panels[i].get_node("randUpgradeButton"+str(i+1))
		buy_button.text = "Buy: " + str(costs_and_tiers[upgrade][(upgrades[upgrade])+1])

func _on_rand_upgrade_button_1_pressed() -> void:
	var upgrade = rand3[0]
	gm.souls = gm.souls - costs_and_tiers[upgrade][(upgrades[upgrade])+1]
	upgrades[upgrade] += 1
	var buy_button = rand_upgrade_panels[0].get_node("randUpgradeButton1")
	buy_button.text = "Buy: " + str(costs_and_tiers[upgrade][(upgrades[upgrade])+1])

func _on_rand_upgrade_button_2_pressed() -> void:
	var upgrade = rand3[1]
	gm.souls = gm.souls - costs_and_tiers[upgrade][(upgrades[upgrade])+1]
	upgrades[upgrade] += 1
	var buy_button = rand_upgrade_panels[1].get_node("randUpgradeButton2")
	buy_button.text = "Buy: " + str(costs_and_tiers[upgrade][(upgrades[upgrade])+1])

func _on_rand_upgrade_button_3_pressed() -> void:
	var upgrade = rand3[2]
	gm.souls = gm.souls - costs_and_tiers[upgrade][(upgrades[upgrade])+1]
	upgrades[upgrade] += 1
	var buy_button = rand_upgrade_panels[2].get_node("randUpgradeButton3")
	buy_button.text = "Buy: " + str(costs_and_tiers[upgrade][(upgrades[upgrade])+1])

func _on_active_skill_button_pressed() -> void:
	pass # Replace with function body.

func _on_refresh_button_pressed() -> void:
	gm.souls = gm.souls - (2**num_refresh)+1
	num_refresh += 1
	refresh_shop()

func _on_exit_shop_pressed() -> void:
	$".".hide()
	get_tree().paused = false

func _on_ball_damage_button_pressed() -> void:
	var cost = costs_and_tiers[-1][upgrades[-1]]
	gm.souls = gm.souls - cost
		
func _on_visibility_changed() -> void:
	if visible:
		refresh_shop()
	else:
		pass
