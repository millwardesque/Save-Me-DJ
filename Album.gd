extends Area2D

var Events
var AlbumLibrary

export var artist = '<unknown>'
export var title = '<untitled>'
export var year = 'year'
export var colour = Color(1.0, 1.0, 1.0)

var album_shelf setget album_shelf_set, album_shelf_get
var highlight_colour
var artists
var titles


func _ready():
	Events = get_node("/root/Events")
	AlbumLibrary = get_node("/root/AlbumLibrary")
	artists = AlbumLibrary.ARTISTS
	titles = AlbumLibrary.TITLES
	
	var colour_vec = Vector3(randf(), randf(), randf())
	colour_vec = colour_vec.normalized()
	colour = Color(colour_vec.x, colour_vec.y, colour_vec.z)
	$AnimatedSprite.set_modulate(colour)
	highlight_colour = Color(0.0, 1.0, 0.0)
	
	artist = artists[randi() % artists.size()]
	title = titles[randi() % titles.size()]
	year = int(rand_range(1950, 2050))

func album_string():
	return artist + ' - ' + title + ' (' +str(year) + ')'
	
func album_shelf_set(new_shelf):
	album_shelf = new_shelf
	
func album_shelf_get():
	return album_shelf
	
func decade():
	return int(floor(year / 10) * 10)

func _on_Album_mouse_entered():
	$AnimatedSprite.set_modulate(highlight_colour)
	Events.emit_signal('album_highlighted', self)

func _on_Album_mouse_exited():
	$AnimatedSprite.set_modulate(colour)
	Events.emit_signal('album_unhighlighted')

func _on_Album_input_event(_viewport, event, _shape_idx):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		Events.emit_signal('album_selected', self)
	elif (event.is_pressed() and event.button_index == BUTTON_RIGHT):
		Events.emit_signal('album_contextual_action', self)
