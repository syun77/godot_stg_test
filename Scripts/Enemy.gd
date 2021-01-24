extends KinematicBody2D

# 体力
var hp = 5

# 移動量
var velocity = Vector2()

func start(x, y, deg, speed):
	position = Vector2(x, y)
	velocity.x = speed * cos(deg2rad(deg))
	velocity.y = speed * -sin(deg2rad(deg))

func hit(damage):
	# ダメージ処理
	hp -= damage
	if hp <= 0:
		# 消滅
		queue_free()

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	if Global.isInScreen(self) == false:
		queue_free()
	
	# 当たり判定
	var col = move_and_collide(velocity * delta)
	# TODO: 未実装
