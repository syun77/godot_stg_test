extends Node2D

var _timer = 0.0

func _process(delta: float) -> void:
	_timer += delta
	if _timer > 0.5:
		var rate = 1 - (_timer - 0.5) / 0.5
		modulate.a = rate
		if _timer > 1.0:
			queue_free()
