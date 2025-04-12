extends VBoxContainer
@onready var game_manager: Node = %GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var reserve = game_manager.remainingBalls
	for ball in range(reserve):
		create_menu_item()
		add_spacer(false)
	#print_tree_pretty()

func _on_game_manager_update_balls() -> void:
	var reserve = game_manager.remainingBalls
	print(reserve)
	var num_children = self.get_child_count()
	if num_children < reserve:
		print("add ball to reserve")
		create_menu_item()
	elif num_children > reserve:
		print("remove ball from reserve")
		var child_list = get_children()
		var spacer = child_list[-1]
		var most_recent_child = child_list[-2]
		spacer.queue_free()
		most_recent_child.queue_free()
		$".".size.y -= 64
	else:
		print("you fucked up buddy!")
		
func create_menu_item() -> void:
	$".".size.y += 64
	var divider = HBoxContainer.new()
	divider.set_size(Vector2(32, 32))
	divider.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(divider)
	var ball_sprite = Sprite2D.new()
	ball_sprite.z_index = 1
	ball_sprite.texture = load("res://assets/bbrl_skeleton_assets.png")
	ball_sprite.region_enabled = true
	ball_sprite.region_rect = Rect2(32, 32, 32, 32)
	divider.add_child(ball_sprite)
