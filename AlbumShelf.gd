extends Node2D

export var max_albums = 10
export var album_width = 4
export (PackedScene) var empty_album

var albums = [] setget ,albums_get

# Called when the node enters the scene tree for the first time.
func _ready():
	albums.resize(max_albums)
	for i in range(max_albums):
		add_album(i, empty_album.instance())

func albums_get():
	var real_albums = []
	for i in range(max_albums):
		if albums[i].get_filename() != empty_album.get_path():
			real_albums.append(albums[i])
	
	return real_albums
	
func replace_album(new_album, to_be_replaced):
	var index = album_index(to_be_replaced)
	if index != null:
		remove_album(index)
		add_album(index, new_album)	
		return to_be_replaced
	else:
		return null
	
func set_empty_album(index):
	if index != null:
		var old_album = remove_album(index)
		add_album(index, empty_album.instance())
		return old_album
	else:
		return null
		
func album_index(album):
	for i in range(max_albums):
		if albums[i] == album:
			return i 
	return null			

func add_album(index, album):
	if index >= 0 and index < max_albums:
		add_child(album)
		albums[index] = album
		album.album_shelf = self
		album.position.y = -58
		album.position.x = index * album_width

func remove_album(index):
	if index != null and index >= 0 and index < max_albums and albums[index] != null:
		var to_remove = albums[index]
		to_remove.album_shelf = null
		remove_child(to_remove)
		return to_remove
	else:
		return null
		
func has_space():
	return next_empty_album() != null
	
func next_empty_album():
	for i in range(max_albums):
		if albums[i].get_filename() == empty_album.get_path():
			return i
			
	return null
	
