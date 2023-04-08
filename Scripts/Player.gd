extends Area2D

# ショットシーンを読み込み
const Shot = preload("res://Scenes/Shot.tscn")
var Particle = preload("res://Scenes/Particle.tscn")

@onready var _spr = $Sprite2D

var cnt = 0

func destroy():
	# 消滅
	queue_free()
	var p = Particle.instantiate()
	p.start(position.x, position.y, Color.ORANGE_RED)
	var main_node = get_parent()
	main_node.add_child(p)	

func hit(damage):
	# ダメージを受けたらゲームオーバーにする
	destroy()
	
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	# 移動速度
	var spd = 500 * delta
	if Input.is_action_pressed("ui_select"):
		# Spaceキーを押しているとスロー
		spd = 200 * delta
	
	_spr.frame = 1
	var v = Vector2()
	if Input.is_action_pressed("ui_up"):
		v.y -= 1 # 上に移動
	if Input.is_action_pressed("ui_down"):
		v.y += 1 # 下に移動
	if Input.is_action_pressed("ui_left"):
		v.x -= 1 # 左に移動
		_spr.frame = 0
	if Input.is_action_pressed("ui_right"):
		v.x += 1 # 右に移動
		_spr.frame = 2
	
	position += v.normalized() * spd
	
	# 画面外に出ないようにする	
	if position.x < Global.VIEW_X:
		position.x = Global.VIEW_X
	if position.x > Global.VIEW_W:
		position.x = Global.VIEW_W
	if position.y < Global.VIEW_Y:
		position.y = Global.VIEW_Y
	if position.y > Global.VIEW_H:
		position.y = Global.VIEW_H
	
	# Spaceキーを押したらショットを発射
	if Input.is_action_pressed(("ui_select")):
		cnt += delta
		if cnt > 0.1:
			cnt -= 0.1
			# ショット生成
			var shot = Shot.instantiate()
			shot.position = position
			
			# 移動量を設定
			shot.start(position.x, position.y, 90, 1000)
			
			# ルートノードを取得
			var main_node = get_owner()
			main_node.add_child(shot)

