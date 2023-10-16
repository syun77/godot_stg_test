extends Area2D

class_name Enemy

const APPEAR_ITEM = true

# 敵弾オブジェクト
var Bullet   = preload("res://Scenes/Bullet.tscn")
var Particle = preload("res://Scenes/Particle.tscn")
var ItemObj  = preload("res://Item.tscn")

@export var id = 0
var id_previous = 0
var target = null

var size_tbl = [0, 1,  1,  0.3, 1,  1,  1]
var hp_tbl   = [0, 8,  10, 5,   10, 10, 10]
var dst_tbl  = [0, 5,  10, 8,   10, 9,  10]

# 体力
var hp = 5

# 初期化フラグ
var is_init = false

# 移動量
var velocity = Vector2()

# 速度減衰値
var decay_velocity = 0.95

var decay_time = 0
var past_time = 0
var destroy_time = -1
var _wait = 0
var _step = 0
var _cnt = 0

var func_ai:Callable

# NWayを撃つ
func nway(n, center, wide, speed, delay=0):
	if n < 1:
		return
	
	var d = wide / n
	var a = center - (d * 0.5 * (n - 1))
	for i in range(n):
		bullet(a, speed, delay)
		a += d

# 弾を撃つ
func bullet(deg, speed, delay=0):
	if delay > 0:
		# 遅延して発射する
		await get_tree().create_timer(delay).timeout
	
	var bullet = Bullet.instantiate()
	bullet.start(position.x, position.y, deg, speed)
	# ルートノードを取得
	Common.bullets.add_child(bullet)

func start(eid, x, y, deg, speed):
	id = eid
	id_previous = id
	hp = hp_tbl[eid]
	destroy_time = dst_tbl[eid]
	var sc = size_tbl[eid]
	scale = Vector2(sc, sc)
	
	position = Vector2(x, y)
	velocity.x = speed * cos(deg_to_rad(deg))
	velocity.y = speed * -sin(deg_to_rad(deg))

func hit(damage):
	# ダメージ処理
	hp -= damage
	if hp <= 0:
		# 消滅
		destroy()

func wait(t):
	_wait += t

func ai_1():
	# 高速狙い撃ち弾を撃つ
	match _step:
		0:
			wait(1)
			_step += 1
		1:
			for i in range(5):
				aim(700, i * 0.05)
			wait(0.8)

func ai_2():
	# 両サイドから攻撃する
	match _step:
		0:
			wait(1)
			_step += 1
		1:
			velocity.x = 0
			decay_velocity = 1.001 # 速度減衰無効
			velocity = Vector2(0, 100)
			_step += 1
		2:
			var dir = 0-20
			if position.x > Global.VIEW_W/2:
				dir = 180+20
			for i in range(16):
				bullet(dir, 500, i * 0.03)
			wait(1)

func ai_3():
	# 狙い撃ち弾
	match _step:
		0:
			wait(2)
			_step += 1
		1:
			for i in range(5):
				aim(300)
			wait(1.5)

func ai_4():
	# ワインダー
	match _step:
		0:
			wait(2)
			_step += 1
		1:
			_cnt = 0
			_step += 1
		2:
			var dir = 270 + 20 * sin(deg_to_rad(_cnt*4))
			bullet(dir, 500)
			_cnt += 1
			wait(0.05)

func ai_5():
	# ウィップ弾.
	match _step:
		0:
			wait(2)
			_step += 1
		1:
			_cnt = 3
			_step += 2
		2:
			var dir = get_aim()
			for i in range(_cnt + 2):
				nway(_cnt, dir, 60, 300+(50*i), 0.02 * i * _cnt)
			wait(2)
			_cnt += 1

func ai_6():
	# 回転弾
	match _step:
		0:
			wait(2)
			_step += 1
		1:
			_cnt = 0 # 横から開始
			_step += 1
		2:
			wait(0.05)
			_step += 1
		3:
			var d = 8 # 回転速度
			bullet(_cnt, 200)
			bullet(_cnt+180, 200)
			if position.x < Global.VIEW_W/2:
				_cnt += d
			else:
				_cnt -= d
			_step = 2
		

func create_ai():
	match id:
		1: return ai_1
		2: return ai_2
		3: return ai_3
		4: return ai_4
		5: return ai_5
		6: return ai_6
		_: return ai_1

func aim(spd, delay=0):
	var deg = get_aim()
	bullet(deg, spd, delay)
	
func get_aim():
	return Global.get_aim(self)

func _ready():
	target = $"../Player"
	
func destroy():
	if id == 1:
		if APPEAR_ITEM:
			# アイテム出現
			var item = ItemObj.instantiate()
			item.position = position
			item._velocity.y = -500
			item._velocity.x = randf_range(-300, 300)
			Common.enemies.add_child(item)
	
	var p = Particle.instantiate()
	p.start(position.x, position.y, Color.MEDIUM_SEA_GREEN)
	var main_node = get_parent()
	main_node.add_child(p)
	queue_free()
	
func _physics_process(delta):
	
	if id != id_previous:
		# idが切り替わった
		id_previous = id
		is_init = false # 初期化し直す
		_wait = 0
	
	if is_init == false:
		# 初期化
		is_init = true
		func_ai = create_ai()
		
	_wait -= delta
	if _wait <= 0:
		if func_ai:
			func_ai.call()

	if Global.isInScreen(self) == false:
		destroy()
	
	decay_time += 60 * delta
	while decay_time > 1:
		velocity *= decay_velocity
		decay_time -= 1
	
	# 移動	
	position += velocity * delta
	
	past_time += delta
	if destroy_time > 0:
		if past_time > destroy_time:
			# 自爆
			destroy()
