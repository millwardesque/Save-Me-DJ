extends Node

export (PackedScene) var Album
export (int) var starting_albums_per_shelf = 1
var Events
var selected_album
var active_question = null
var score = 0 setget score_set

var max_hp = 100.0
var hp = 0.0 setget hp_set
var hp_drain_per_sec = 2

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
	Events.connect('phone_caller_hangup', self, '_on_phone_caller_hangup')
	Events.connect('phone_update_message', self, '_on_phone_update_message')
		
	hp_set(max_hp)
	
	score_set(0)
	
	for i in range(0, starting_albums_per_shelf):
		$AlbumShelf.remove_album(i)
		$AlbumShelf.add_album(i, Album.instance())
		
		$AlbumShelf2.remove_album(i)
		$AlbumShelf2.add_album(i, Album.instance())
	
	$NewAlbumTimer.start()
	$NewPhoneTimer.start()
	$HPCountdownTimer.start()
	
func _on_album_highlighted(album):
	$HighlightedAlbumTooltip.set_message(album.album_string())
	$HighlightedAlbumTooltip.set_position(Vector2(album.global_position.x, album.global_position.y - $HighlightedAlbumTooltip.rect_size.y - 10))

func _on_album_unhighlighted():
	$HighlightedAlbumTooltip.clear_message()
	
func _on_album_selected(album):
	selected_album = album
	
	var mouse_position = get_viewport().get_mouse_position()
	$SelectedAlbumDialogBox.set_position(Vector2(mouse_position.x, mouse_position.y + 5))
	$SelectedAlbumDialogBox.set_message(album.album_string())
	
func _on_album_contextual_action(album):
	if selected_album != null and selected_album != album:
		# Remove the selected album from its shelf
		if selected_album.album_shelf != null:
			var selected_index = selected_album.album_shelf.album_index(selected_album)
			selected_album.album_shelf.set_empty_album(selected_index)
		elif selected_album == $RecordPlayer.album:
			$RecordPlayer.album = null
			$NowPlayingDialogBox.clear_message()
		
		# Replace the clicked album with the selected album
		album.album_shelf.replace_album(selected_album, album)
		
		_on_album_selected(album)

func _on_album_deselected():
	selected_album = null
	$SelectedAlbumDialogBox.clear_message()

func _on_empty_album_contextual_action(album):
	if selected_album != null:
		# Remove the selected album from its shelf
		if selected_album.album_shelf != null:
			var selected_index = selected_album.album_shelf.album_index(selected_album)
			selected_album.album_shelf.set_empty_album(selected_index)
		elif selected_album == $RecordPlayer.album:
			$RecordPlayer.album = null
			$NowPlayingDialogBox.clear_message()
		
		# Replace the clicked album with the selected album
		album.album_shelf.replace_album(selected_album, album)
		
		_on_album_deselected()

func _input(event):
	if selected_album != null and event is InputEventMouseMotion:
		$SelectedAlbumDialogBox.set_position(Vector2(event.position.x, event.position.y + 5))
	
func _on_NewAlbumTimer_timeout():
	var next_space = $AlbumInbox.next_empty_album()
	if next_space != null:
		$AlbumInbox.remove_album(next_space)
		$AlbumInbox.add_album(next_space, Album.instance())

func _on_NewPhoneTimer_timeout():
	if not $Phone.is_ringing and not $Phone.is_online:
		$Phone.trigger_call()
		$NoAnswerPhoneTimer.start()

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
				score_set(score + 1)
				hp_set(hp + 5)
				$Phone.question_answered()
			else:
				$PhoneSpeaker/PhoneDialogBox.set_message("Nah, try again! " + active_question['question'])
			
		$NowPlayingDialogBox.set_message(record_player.album.album_string())
		
func _on_phone_contextual_action(phone):
	if phone.is_ringing:
		$NoAnswerPhoneTimer.stop()
		active_question = phone.answer_call($RecordPlayer.album, all_albums())
		$PhoneSpeaker/PhoneDialogBox.set_message(active_question['question'])
	elif phone.is_online:
		end_call(phone)

func _on_phone_caller_hangup(phone):
	end_call(phone)
	
func _on_phone_update_message(phone, new_message):
	$PhoneSpeaker/PhoneDialogBox.set_message(new_message)

func _on_NoAnswerPhoneTimer_timeout():
	end_call($Phone)
	
func end_call(phone):
	phone.end_call()
	active_question = null
	$NoAnswerPhoneTimer.stop()	# Reset the phone timer
	$NewPhoneTimer.start()	# Reset the phone timer

	$PhoneSpeaker/PhoneDialogBox.clear_message()
	
func all_albums():
	var albums = []
	
	albums += $AlbumShelf.albums
	albums += $AlbumShelf2.albums
	albums += $AlbumInbox.albums
	
	if $RecordPlayer.album:
		albums.append($RecordPlayer.album)
		
	return albums
	
func score_set(value):
	score = value
	$HUD.set_score(score)
	
func hp_set(value):
	var is_dead = false
	hp = value
	if hp <= 0.0:
		is_dead = true
		hp = 0.0
		
	$HUD.set_hp(hp)
	
	if is_dead:
		_on_game_over()

func _on_HPCountdownTimer_timeout():
	hp_set(hp - hp_drain_per_sec)

func _on_game_over():
	get_tree().change_scene("res://GameOver.tscn")
