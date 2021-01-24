extends Node2D

# ショットシーンを読み込み
const Shot = preload("res://Scenes/Shot.tscn")

func _ready():
	pass # Replace with function body.

func _process(delta):
	# 移動速度
	var spd = 500 * delta
	
	if Input.is_action_pressed("ui_up"):
		position.y -= spd # 上に移動
	if Input.is_action_pressed("ui_down"):
		position.y += spd # 下に移動
	if Input.is_action_pressed("ui_left"):
		position.x -= spd # 左に移動
	if Input.is_action_pressed("ui_right"):
		position.x += spd # 右に移動
	
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
	if Input.is_action_just_pressed(("ui_select")):
		# ショット生成
		var shot = Shot.instance()
		shot.position = position
		
		# 移動量を設定
		shot.start(position.x, position.y, 90, 1000)
		
		# ルートノードを取得
		var main_node = get_owner()
		main_node.add_child(shot)

