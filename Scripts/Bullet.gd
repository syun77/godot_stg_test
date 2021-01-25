# 物理シュミレートしない物理挙動を持つオブジェクト
extends KinematicBody2D

# 移動方向
var velocity = Vector2()

# 開始
func start(x, y, deg, speed):
	position = Vector2(x, y)
	velocity.x = speed * cos(deg2rad(deg))
	velocity.y = speed * -sin(deg2rad(deg))

func _ready():
	pass

func _physics_process(delta):
	if Global.isInScreen(self) == false:
		# 画面外に出たので削除
		queue_free()

	# 移動と衝突判定を行う
	var col = move_and_collide(velocity * delta)
	if col:
		if col.collider.name == "Player":
			# プレイヤーと衝突したので削除
			col.collider.hit(1) # 敵に1ダメージ
			queue_free()
