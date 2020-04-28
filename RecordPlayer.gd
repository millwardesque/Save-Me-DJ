extends Area2D

var Events

var album setget album_set, album_get

# Called when the node enters the scene tree for the first time.
func _ready():
	Events = get_node("/root/Events")
	$RecordSprite.animation = 'off'
	$RecordSprite.set_modulate(Color(1.0, 1.0, 1.0))
	
func now_playing_string():
	if album != null:
		return album.album_string()
	else:
		return "";

func album_get():
	return album
	
func album_set(new_album):
	var old_album = album
	if old_album != null:
		old_album.show()
		remove_child(old_album)
	
	if new_album != null:
		add_child(new_album)
		new_album.hide()
		new_album.album_shelf = null
		$RecordSprite.animation = 'on'
		$RecordSprite.set_modulate(new_album.colour)
	else:
		$RecordSprite.animation = 'off'
		$RecordSprite.set_modulate(Color(1.0, 1.0, 1.0))
	
	album = new_album

	return old_album
	
func _on_RecordPlayer_input_event(_viewport, event, _shape_idx):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		Events.emit_signal('record_player_selected', self)
	elif (event.is_pressed() and event.button_index == BUTTON_RIGHT):
		Events.emit_signal('record_player_contextual_action', self)
