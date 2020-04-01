extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide_game_over()

func set_highlighted_album(album_string):
	if album_string != "":
		album_string = "Highlighted: " + album_string
	$HighlightedAlbum.text = album_string

func clear_highlighted_album():
	$HighlightedAlbum.text = ""

func set_selected_album(album_string):
	if album_string != "":
		album_string = "Selected: " + album_string
	$SelectedAlbum.text = album_string

func clear_selected_album():
	$SelectedAlbum.text = ""

func set_playing_album(album_string):
	if album_string != "":
		album_string = "Now playing: " + album_string
	$PlayingAlbum.text = album_string

func clear_playing_album():
	$PlayingAlbum.text = "Now playing: Nothing"

func set_phone_dialog(dialog_string):
	if dialog_string != "":
		dialog_string = "Caller: " + dialog_string
	$PhoneDialog.text = dialog_string

func clear_phone_dialog():
	$PhoneDialog.text = "<no caller>"

func set_score(score):
	$Score.text = "Score: " + str(score)
	
func set_hp(hp):
	$HP.text = "HP: " + str(int(hp))

func show_game_over(score):
	$GameOver.text = "Game over!\nScore: " + str(score)
	$GameOver.show()

func hide_game_over():
	$GameOver.hide()
