extends Area2D

var Events

var questions = [
	{
		"question": "Help! Play something from the {decade}s",
		"answer_predicates": {
			"decade": null,
		},
	},
	{
		"question": "Help! Play something from {artist}",
		"answer_predicates": {
			"artist": null,
		},
	},
	{
		"question": "Can you play that song {title}",
		"answer_predicates": {
			"title": null,
		},
	},
]

var is_ringing = false setget ,is_ringing_get
var is_online = false setget ,is_online_get
var active_question = null

func _ready():
	Events = get_node("/root/Events")
	
func is_ringing_get():
	return is_ringing
	
func is_online_get():
	return is_online
	
func trigger_call():
	is_ringing = true
	is_online = false
	active_question = null
	
	$AnimatedSprite.set_modulate(Color(1.0, 0.0, 0.0))
	
func answer_call(currently_playing, all_albums):
	is_ringing = false
	is_online = true
	
	$AnimatedSprite.set_modulate(Color(0.0, 1.0, 0.0))
	
	var generate_question = true
	while generate_question:
		active_question = questions[randi() % questions.size()].duplicate()
		fill_template(active_question, all_albums)
		
		generate_question = false
		if currently_playing != null:
			generate_question = check_album(currently_playing)
	
	$CallDurationTimer.start()
	return active_question
		
func end_call():
	is_ringing = false
	is_online = false
	active_question = null
	$AnimatedSprite.set_modulate(Color(1.0, 1.0, 1.0))
	$CallDurationTimer.stop()
	
func check_album(album):
	if active_question:
		if active_question.answer_predicates.has('decade') and active_question.answer_predicates['decade'] != album.decade():
			return false
		
		if active_question.answer_predicates.has('artist') and active_question.answer_predicates['artist'] != album.artist:
			return false
			
		if active_question.answer_predicates.has('title') and active_question.answer_predicates['title'] != album.title:
			return false

		return true
	return null
	
func fill_template(question, all_albums):	
	var artists = {}
	var decades = {}
	var titles = {}
	for album in all_albums:
		artists[album.artist] = 0
		decades[album.decade()] = 0
		titles[album.title] = 0
	var artist = artists.keys()[randi() % artists.keys().size()]
	var decade = decades.keys()[randi() % decades.keys().size()]
	var title = titles.keys()[randi() % titles.keys().size()]
	
	question["question"] = question["question"].replace('{artist}', artist)
	question["question"] = question["question"].replace('{decade}', decade)
	question["question"] = question["question"].replace('{title}', title)
	
	if question["answer_predicates"].has("artist"):
		question["answer_predicates"]["artist"] = artist
		
	if question["answer_predicates"].has("decade"):
		question["answer_predicates"]["decade"] = decade
		
	if question["answer_predicates"].has("title"):
		question["answer_predicates"]["title"] = title

func _on_Phone_input_event(_viewport, event, _shape_idx):
	if (event.is_pressed() and event.button_index == BUTTON_RIGHT):
		Events.emit_signal('phone_contextual_action', self)


func _on_CallDurationTimer_timeout():
	Events.emit_signal('phone_caller_hangup', self)
