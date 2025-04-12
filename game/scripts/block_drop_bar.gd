extends TextureProgressBar
signal full

func _ready() -> void:
	$".".value = 0

func cycle_completed():
	if $".".value == $".".max_value:
		$".".value = $".".min_value
		# then flag row to be dropped
		full.emit()
	else: 
		$".".value += 1
