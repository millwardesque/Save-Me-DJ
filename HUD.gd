extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_hightlighted_album(album_string):
	$HighlightedAlbum.text = album_string

func clear_hightlighted_album():
	$HighlightedAlbum.text = ""

func set_selected_album(album_string):
	$SelectedAlbum.text = album_string

func clear_selected_album():
	$SelectedAlbum.text = ""
