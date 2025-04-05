extends Node

class_name Item

var texture: Texture2D
var id: int
var parent: TextureRect

func _init(texture: Texture2D, id: int, parent: TextureRect):
	self.texture = texture
	self.id = id
	self.parent = parent
	
func get_t():
	return self.texture
	
func get_id():
	return self.id 

func clear():
	self.texture = null 
	self.id = -1
	
func set_new(texture, id):
	self.texture = texture
	self.id = id
	
