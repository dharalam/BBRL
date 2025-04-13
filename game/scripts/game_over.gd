extends CanvasLayer

func _ready() -> void:
	$".".hide()

func _on_continue_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_game_manager_game_over() -> void:
	get_tree().paused = true
	$".".show()
