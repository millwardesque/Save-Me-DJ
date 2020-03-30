extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
