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
	
	# Spaceキーを押したらショットを発射
	if Input.is_action_just_pressed(("ui_select")):
		# ショット生成
		var shot = Shot.instance()
		shot.position = position
		
		# ルートノードを取得
		var main_node = get_owner()
		main_node.add_child(shot)

