extends Area2D

@onready var gm = %GameManager

func _on_body_entered(body):
	print("skull drop")
	gm.ballDrop()
	#get_tree().reload_current_scene()
	body.queue_free()
	
