extends Area2D

const BLINK_TYPE = 2

const GRAVITY = 10

@onready var _spr:Sprite2D = $Power2

var _cnt = 0
var _velocity = Vector2.ZERO

func _ready() -> void:
	_cnt = randi()

func _physics_process(delta: float) -> void:
	_velocity.y += GRAVITY
	_velocity *= 0.9
	position += _velocity * delta
	
	_cnt += 1
	visible = true
	
	match BLINK_TYPE:
		0:
			pass
		1:
			if _cnt%4 < 2:
				visible = false
		2:
			_spr.visible = true
			_spr.modulate.a = 0.8 * abs(sin(_cnt * 0.05))

	if position.y > 800:
		queue_free()
