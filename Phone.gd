extends Area2D

var Events

var questions = [
	{
		"question": "Help! Play something from the {decade}s",
		"answer_predicates": {
			"decade": null,
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
	
func answer_call():
	is_ringing = false
	is_online = true
	
	$AnimatedSprite.set_modulate(Color(0.0, 1.0, 0.0))
	active_question = questions[randi() % questions.size()].duplicate()
	fill_template(active_question)
	return active_question
		
func end_call():
	is_ringing = false
	is_online = false
	active_question = null
	$AnimatedSprite.set_modulate(Color(1.0, 1.0, 1.0))
	
func check_album(album):
	if active_question:
		if active_question.answer_predicates.has('decade') and active_question.answer_predicates['decade'] != album.decade():
			return false

		return true
	return null
	
func fill_template(question):
	var year = int(rand_range(1950, 2050))
	var decade = int(floor(year / 10)) * 10
	
	question["question"] = question["question"].replace('{decade}', decade)
	
	if question["answer_predicates"].has("decade"):
		question["answer_predicates"]["decade"] = decade	

func _on_Phone_input_event(_viewport, event, _shape_idx):
	if (event.is_pressed() and event.button_index == BUTTON_RIGHT):
		Events.emit_signal('phone_contextual_action', self)
