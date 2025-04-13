extends Button

var gm

func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")


func _process(delta: float) -> void:
	var cost = text.split(": ")
	cost = int(cost[1])
	if cost > gm.souls:
		disabled = true
		# icon = load(...) some big red X
	else:
		disabled = false
		# icon = load(...) some big green checkmark i guess
