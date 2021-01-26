extends Area2D

# 敵弾オブジェクト
var Bullet = preload("res://Scenes/Bullet.tscn")

# 体力
var hp = 5

# 初期化フラグ
var is_init = false

# 移動量
var velocity = Vector2()

# 弾を撃つ
func bullet(deg, speed):
	var bullet = Bullet.instance()
	bullet.start(position.x, position.y, deg, speed)
	# ルートノードを取得
	var main_node = get_owner()
	main_node.add_child(bullet)
		
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
	pass

func _physics_process(delta):
	if is_init == false:
		is_init = true
		# 1秒ごとに弾を撃つテスト
		while true:
			yield(get_tree().create_timer(1), "timeout")
			bullet(270, 500)


	if Global.isInScreen(self) == false:
		queue_free()
	
	# 移動
	position += velocity * delta
	
