extends Area2D

var Events

export var artist = '<unknown>'
export var title = '<untitled>'
export var year = 'year'
export var colour = Color(1.0, 1.0, 1.0)

var album_shelf setget album_shelf_set, album_shelf_get
var highlight_colour

var artists = [
	'Makoto Matsushita',
	'Marasy8',
	'The Consouls',
	'Tommy Emmanuel',
	'Magic Sword',
	'Seasick Steve'	
]

var titles = [
	"The dreamer",
	"I am one",
	"Many treats to Al Shishkabab",
	"Dancer dancer",
	"What we saw",
	"Who is the man in the ladies' hat?"
]


func _ready():
	Events = get_node("/root/Events")
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
