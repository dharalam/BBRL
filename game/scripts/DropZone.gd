extends Area2D

@onready var gm = %GameManager
@onready var collision_shape = $CollisionShape2D

func _on_body_entered(body):
	#print("skull drop")
	if body is Ball:
		gm.ballDrop()
	#get_tree().reload_current_scene()
	body.call_deferred("free")
	
