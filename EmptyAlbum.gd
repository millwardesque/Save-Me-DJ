extends Area2D

var Events

var album_shelf setget album_shelf_set, album_shelf_get
var colour
var highlight_colour

func _ready():
	Events = get_node("/root/Events")
	colour = Color(1.0, 1.0, 1.0)
	$AnimatedSprite.set_modulate(colour)
	highlight_colour = Color(0.0, 1.0, 0.0)

func album_string():
	return "<Empty Album>"

func album_shelf_set(new_shelf):
	album_shelf = new_shelf
	
func album_shelf_get():
	return album_shelf

func _on_EmptyAlbum_input_event(_viewport, event, _shape_idx):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		Events.emit_signal('empty_album_selected', self)
	elif (event.is_pressed() and event.button_index == BUTTON_RIGHT):
		Events.emit_signal('empty_album_contextual_action', self)

func _on_EmptyAlbum_mouse_entered():
	$AnimatedSprite.set_modulate(highlight_colour)

func _on_EmptyAlbum_mouse_exited():
	$AnimatedSprite.set_modulate(colour)
