extends CanvasLayer

const VIEW_X = 32  # 画面の左上(X)
const VIEW_Y = 0   # 画面の左上(Y)
const VIEW_W = 800 # 画面の右下(X)
const VIEW_H = 600 # 画面の右下(Y)

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
