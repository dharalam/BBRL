extends CanvasLayer
class_name Shop

var gm
enum refreshables {BSPEED, PSPEED, BSIZE, PSIZE, BOMB, CHARGE, CYCLES, ACTIVE, POWER}
enum powers {NONE, MULTIBALL, FREEZE, SPEEDUP, LIGHTNING}
@onready var ball_damage_button: Button = $PanelContainer/MarginContainer/VBoxContainer/PermanentUpgrades/BallDamageButton
@onready var rand_upgrade_1: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Refreshables/VBoxContainer/randUpgrade1
@onready var rand_upgrade_2: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Refreshables/VBoxContainer/randUpgrade2
@onready var rand_upgrade_3: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Refreshables/VBoxContainer/randUpgrade3
@onready var rand_active_skill: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Refreshables/VBoxContainer/randActiveSkill
@onready var rand_upgrade_panels = [rand_upgrade_1, rand_upgrade_2, rand_upgrade_3]
@onready var refresh_button: Button = $"PanelContainer/MarginContainer/VBoxContainer/Refreshables/Refresh Tab/RefreshButton"
@onready var power_display: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/Refreshables/VBoxContainer/randActiveSkill/VBoxContainer/HBoxContainer/PowerDisplay
@onready var power_icons = preload("res://assets/powers.png")

var num_refresh = 0
var populated = false
var active_bought = false
var rand3
var rand_active
var active_skill_bar

var power_atlas = AtlasTexture.new()

var regions = {
	powers.NONE: Rect2(0, 0, 32, 32),
	powers.MULTIBALL: Rect2(32, 0, 32, 32),
	powers.FREEZE: Rect2(64, 0, 32, 32),
	powers.SPEEDUP: Rect2(96, 0, 32, 32),
	powers.LIGHTNING: Rect2(128, 0, 32, 32)
}

var power_names = {
	powers.NONE: "None",
	powers.MULTIBALL: "Multiball",
	powers.FREEZE: "Freeze",
	powers.SPEEDUP: "Speed-Up",
	powers.LIGHTNING: "Lightning-in-a-Bottle"
}

var upgrade_names = {
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

var costs = {
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

var tiers = {
	-1: {0: 0, 1: 1, 2: 2, 3: 3}, #ball damage
	refreshables.BSPEED: {0: 400, 1: 1.2, 2: 1.5, 3: 1.7},
	refreshables.PSPEED: {0: 250, 1: 1.5, 2: 1.7, 3: 1.9},
	refreshables.BSIZE: {0: 1.0, 1: 2.0, 2: 2.5, 3: 3.0},
	refreshables.PSIZE: {0: 1.0, 1: 1.25, 2: 1.5, 3: 2},
	refreshables.BOMB: {0: 5, 1: 2, 2: 4, 3: 6, 4: 8, 5: 10},
	refreshables.CHARGE: {0: 8, 1: 3, 2: 6, 3: 9},
	refreshables.CYCLES: {0: 1.0, 1: 2.0, 2: 3.0},
	refreshables.ACTIVE: {0: 1.0, 1: 0.75, 2: 0.5, 3: 0.25}
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

var powers_available = {
	powers.MULTIBALL: true,
	powers.FREEZE: true,
	powers.SPEEDUP: true,
	powers.LIGHTNING: true
}

func _ready() -> void:
	$".".hide()

func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")
	active_skill_bar = get_tree().root.get_node("Game/Souls Container/ActiveSkillBar")

func get_available_upgrades() -> Array:
	var retarr = []
	for item in upgrades.keys():
		if upgrades[item] < costs[item].size():
			retarr.append(item)
	return retarr

func get_available_actives() -> Array:
	var retarr = []
	for active in powers_available.keys():
		if powers_available[active] == true:
			retarr.append(active)
	return retarr
	
func sample_without_replacement(items, num_samples):
	randomize()
	var shuffled_items = items.duplicate() # Create a copy to avoid modifying the original
	shuffled_items.erase(-1)
	shuffled_items.shuffle()
	var samples = []
	for i in range(num_samples):
		if shuffled_items.size() > 0:
			samples.append(shuffled_items.pop_back()) # Remove and return the last element
		else:
			break # Stop if array becomes empty
	return samples

func check_if_max_upgrade(idx, button) -> void:
	if upgrades[idx] == len(tiers[idx])-1:
		button.text = "Out of Stock"
	else:
		button.text = "Buy: " + str(costs[idx][(upgrades[idx])+1])

func refresh_shop() -> void:
	power_atlas.set_atlas(power_icons)
	var available_upgrades = get_available_upgrades()
	var available_actives = get_available_actives()
	check_if_max_upgrade(-1, ball_damage_button)
	refresh_button.text = "Buy: " + str(int((pow(2, num_refresh))+1))
	rand3 = sample_without_replacement(available_upgrades, 3)
	rand_active = sample_without_replacement(available_actives, 1)[0]
	for i in range(rand_upgrade_panels.size()):
		var upgrade = rand3[i]
		var name = rand_upgrade_panels[i].get_node("randUpgradeName")
		name.text = upgrade_names[upgrade]
		var buy_button = rand_upgrade_panels[i].get_node("randUpgradeButton"+str(i+1))
		check_if_max_upgrade(upgrade, buy_button)
	if not active_bought:
		var skill_name = rand_active_skill.get_node("VBoxContainer/ActiveSkillName")
		skill_name.text = power_names[rand_active]
		power_atlas.region = regions[rand_active]
		power_display.set_texture(power_atlas)


func _on_rand_upgrade_button_1_pressed() -> void:
	var upgrade = rand3[0]
	gm.souls = gm.souls - costs[upgrade][(upgrades[upgrade])+1]
	upgrades[upgrade] += 1
	var buy_button = rand_upgrade_panels[0].get_node("randUpgradeButton1")
	check_if_max_upgrade(upgrade, buy_button)

func _on_rand_upgrade_button_2_pressed() -> void:
	var upgrade = rand3[1]
	gm.souls = gm.souls - costs[upgrade][(upgrades[upgrade])+1]
	upgrades[upgrade] += 1
	var buy_button = rand_upgrade_panels[1].get_node("randUpgradeButton2")
	check_if_max_upgrade(upgrade, buy_button)

func _on_rand_upgrade_button_3_pressed() -> void:
	var upgrade = rand3[2]
	gm.souls = gm.souls - costs[upgrade][(upgrades[upgrade])+1]
	upgrades[upgrade] += 1
	var buy_button = rand_upgrade_panels[2].get_node("randUpgradeButton3")
	check_if_max_upgrade(upgrade, buy_button)

func _on_active_skill_button_pressed() -> void:
	gm.souls = gm.souls - 3
	active_bought = true
	power_atlas.region = regions[powers.NONE]
	power_display.texture = power_atlas
	if gm.current_power != powers.NONE:
		powers_available[gm.current_power] = true
	var skill_name = rand_active_skill.get_node("VBoxContainer/ActiveSkillName")
	skill_name.text = "Skill Bought"
	var skill_button = rand_active_skill.get_node("ActiveSkillButton")
	skill_button.text = "Out of Stock"
	powers_available[rand_active] = false
	active_skill_bar.change_power(rand_active) # also sets active
	print(powers_available)
	

func _on_refresh_button_pressed() -> void:
	gm.souls = gm.souls - int(pow(2, num_refresh)+1)
	num_refresh += 1
	refresh_shop()

func _on_exit_shop_pressed() -> void:
	$".".hide()
	active_bought = false
	var skill_button = rand_active_skill.get_node("ActiveSkillButton")
	skill_button.disabled = false
	skill_button.text = "Buy: 3"
	get_tree().paused = false
	gm.set_upgrades()

func _on_ball_damage_button_pressed() -> void:
	upgrades[-1] += 1
	gm.ballLevel = tiers[-1][upgrades[-1]]
	var cost = costs[-1][upgrades[-1]]
	gm.souls = gm.souls - cost
	check_if_max_upgrade(-1, ball_damage_button)
	
		
func _on_visibility_changed() -> void:
	if visible:
		refresh_shop()
	else:
		pass
