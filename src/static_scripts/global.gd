class_name Global

static var existing_tweens = {}

static func safe_tween(node : Node) -> Tween:
	if existing_tweens.has(node):
		existing_tweens[node].kill()
	var tween = node.create_tween()
	existing_tweens[node] = tween
	return tween
