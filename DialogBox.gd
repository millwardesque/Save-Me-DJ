extends Panel

export var message = '' setget set_message, get_message

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_message()
	
func clear_message():
	set_message('')
	
func set_message(v):
	$Message.text = v

	if v == '':
		self.hide()
	else:
		self.show()
	
func get_message():
	return $Message.text
