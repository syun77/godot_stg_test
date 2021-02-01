extends CanvasLayer

const VIEW_X = 32  # 画面の左上(X)
const VIEW_Y = 32  # 画面の左上(Y)
const VIEW_W = 480 # 画面の右下(X)
const VIEW_H = 720 # 画面の右下(Y)

var target = null
var is_set_target = false
var last_target = Vector2()

func isInScreen(obj):
	# 画面外チェック
	if obj.position.x < VIEW_X:
		return false
	if obj.position.y < VIEW_Y:
		return false
	if obj.position.x > VIEW_W:
		return false
	if obj.position.y > VIEW_H:
		return false
	
	# 画面内
	return true

func set_target(obj):
	target = obj
	is_set_target = true

func get_aim(obj):
	if is_set_target == false:
		# ターゲットが存在しない場合はマウス位置
		last_target.x = get_viewport().get_mouse_position().x
		last_target.y = get_viewport().get_mouse_position().y
	elif is_instance_valid(target) == false:
		pass # 無効なインスタンスの場合は前回設定した座標
	else:
		# インスタンスから取得可能
		last_target.x = target.position.x
		last_target.y = target.position.y
	

	var dx = last_target.x - obj.position.x	
	var dy = last_target.y - obj.position.y	

	return rad2deg(atan2(-dy, dx))
