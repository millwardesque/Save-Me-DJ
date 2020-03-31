extends Node

export (PackedScene) var Album
var Events
var selected_album
var active_question = null

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
	
	Events.connect('phone_contextual_action', self, '_on_phone_contextual_action')
		
	for i in range(0, 5):
		$AlbumShelf.remove_album(i)
		$AlbumShelf.add_album(i, Album.instance())
		
		$AlbumShelf2.remove_album(i)
		$AlbumShelf2.add_album(i, Album.instance())
	
	$NewAlbumTimer.start()
	$NewPhoneTimer.start()
	
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

func _on_NewPhoneTimer_timeout():
	if not $Phone.is_ringing and not $Phone.is_online:
		$Phone.trigger_call()

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
		
		if active_question != null:
			if $Phone.check_album(record_player.album):
				$Phone.end_call()
				active_question = null
				$HUD.clear_phone_dialog()
			else:
				$HUD.set_phone_dialog("Nah, try again! " + active_question['question'])
			
		$HUD.set_playing_album(record_player.album.album_string())
		
func _on_phone_contextual_action(phone):
	if phone.is_ringing:
		active_question = phone.answer_call()
		$HUD.set_phone_dialog(active_question['question'])
	elif phone.is_online:
		phone.end_call()
		active_question = null
		$NewPhoneTimer.start()	# Reset the phone timer
		$HUD.clear_phone_dialog()
		
# @TODO Phone requests
# 		- Make sure that the album that's playing doesn't match the request
#		- More request types / predicates
# @TODO Timer / succeed / fail phone requests
# @TODO Remove album from shelf/record player on select
# @TODO Basic UI
#	- Show selected album at cursor
# @TODO Score
# @TODO Time elapsed
# @TODO Central artist / title database to minimize space usage
# @TODO Phone request database
# @TODO Polish
#	- Album-on-record-player sprite
# @IDEA Drag-and-drop?
# @IDEA HUD should listen directly for signals?
# @IDEA Combo request types?
# @IDEA Make sure that the player can handle the phone request?
# @IDEA Enemies occasionally attack your place unless you play the right track?
# @IDEA Calls also give clues re: which types of music affect which types of enemies?
