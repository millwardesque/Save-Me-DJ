extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide_game_over()

func set_score(score):
	$Score.text = "Score: " + str(score)
	
func set_hp(hp):
	$HP.text = "HP: " + str(int(hp))

func show_game_over(score):
	$GameOver.text = "Game over!\nScore: " + str(score)
	$GameOver.show()

func hide_game_over():
	$GameOver.hide()
