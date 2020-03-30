extends Node

export (PackedScene) var Album
var Events
var selected_album

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Events = get_node("/root/Events")
	Events.connect('album_highlighted', self, '_on_album_highlighted')
	Events.connect('album_unhighlighted', self, '_on_album_unhighlighted')
	Events.connect('album_selected', self, '_on_album_selected')
	Events.connect('album_deselected', self, '_on_album_deselected')
	
	Events.connect('album_contextual_action', self, '_on_album_contextual_action')
	Events.connect('empty_album_contextual_action', self, '_on_empty_album_contextual_action')

	Events.connect('record_player_selected', self, '_on_record_player_selected')
	Events.connect('record_player_contextual_action', self, '_on_record_player_contextual_action')
		
	for i in range(0, 5):
		$AlbumShelf.remove_album(i)
		$AlbumShelf.add_album(i, Album.instance())
		
		$AlbumShelf2.remove_album(i)
		$AlbumShelf2.add_album(i, Album.instance())
	
	$NewAlbumTimer.start()
	
func _on_album_highlighted(album):
	$HUD.set_highlighted_album(album.album_string())

func _on_album_unhighlighted():
	$HUD.clear_highlighted_album()
	
func _on_album_selected(album):
	selected_album = album
	$HUD.set_selected_album(album.album_string())
	
func _on_album_contextual_action(album):
	if selected_album != null and selected_album != album:
		# Remove the selected album from its shelf
		if selected_album.album_shelf != null:
			var selected_index = selected_album.album_shelf.album_index(selected_album)
			selected_album.album_shelf.set_empty_album(selected_index)
		elif selected_album == $RecordPlayer.album:
			$RecordPlayer.album = null
			$HUD.clear_playing_album()
		
		# Replace the clicked album with the selected album
		album.album_shelf.replace_album(selected_album, album)
		
		_on_album_selected(album)

func _on_album_deselected():
	selected_album = null
	$HUD.clear_selected_album()

func _on_empty_album_contextual_action(album):
	if selected_album != null:
		# Remove the selected album from its shelf
		if selected_album.album_shelf != null:
			var selected_index = selected_album.album_shelf.album_index(selected_album)
			selected_album.album_shelf.set_empty_album(selected_index)
		elif selected_album == $RecordPlayer.album:
			$RecordPlayer.album = null
			$HUD.clear_playing_album()
		
		# Replace the clicked album with the selected album
		album.album_shelf.replace_album(selected_album, album)
		
		_on_album_deselected()

func _on_NewAlbumTimer_timeout():
	var next_space = $AlbumInbox.next_empty_album()
	if next_space != null:
		$AlbumInbox.remove_album(next_space)
		$AlbumInbox.add_album(next_space, Album.instance())

func _on_record_player_selected(record_player):
	if record_player.album != null:
		_on_album_selected(record_player.album)
	
func _on_record_player_contextual_action(record_player):
	if selected_album != null and selected_album != record_player.album:
		# Remove the selected album from its shelf
		if selected_album.album_shelf != null:
			var selected_index = selected_album.album_shelf.album_index(selected_album)
			selected_album.album_shelf.set_empty_album(selected_index)
			
		var old_album = record_player.album
		
		# Put the album on the record player
		record_player.album = selected_album
		
		# Select the old album
		if old_album != null:		
			_on_album_selected(old_album)
		else:
			_on_album_deselected()
			
		$HUD.set_playing_album(record_player.album.album_string())
		
# @TODO Phone requests
# @TODO Timer / succeed / fail phone requests
# @TODO Basic UI
# @TODO Score
# @TODO Time elapsed
# @TODO Artist / title database
# @TODO Polish
#	- Album-on-record-player sprite
# @TODO Drag-and-drop?
# @TODO HUD should listen directly for signals?

