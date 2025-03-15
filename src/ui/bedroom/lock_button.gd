extends Button

var val = 0

func _ready():
	self.pressed.connect(incr)
	
func incr():
	val+=1
	val%=10
	self.text = str(val)

func getVal():
	return str(val)
