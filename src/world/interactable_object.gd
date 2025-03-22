extends MeshInstance3D

@export var enablesOnClick: Node


var highlighted: bool
var highlightColor: Vector4 = Vector4(1, 1, 0, 1)
var highlightSize: float = 1
func _ready() -> void:
	highlighted = false

func _process(delta: float) -> void:
	var looked: bool = Player.player.is_looking_at(self)
	if highlighted != looked:
		if highlighted:
			Global.hide_3d_outline(self)
		else:
			Global.show_3d_outline(self, highlightColor, highlightSize)
		highlighted = looked
	
