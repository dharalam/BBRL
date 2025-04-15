extends Area2D

@onready var gm = %GameManager
@onready var collision_shape = $CollisionShape2D

func _on_body_entered(body):
	if body is Ball:
		gm.ballDrop()
	if body is Brick:
		gm.game_over.emit()
	if body is Ball or body is Brick or body is Soul:
		body.call_deferred("free")
	
