class_name Global

static var existing_tweens = {}

static func safe_tween(node : Node) -> Tween:
	if existing_tweens.has(node):
		existing_tweens[node].kill()
	var tween = node.create_tween()
	existing_tweens[node] = tween
	return tween

static func show_3d_outline(meshNode: MeshInstance3D, color: Vector4, size: float):
	var outlineObj: MeshInstance3D = meshNode.get_node_or_null("_outline")
	if (!outlineObj):
		outlineObj = MeshInstance3D.new()
		meshNode.add_child(outlineObj)
		outlineObj.name = "_outline"
		#var surfaceCount: int = outlineObj.mesh.get_surface_count()
		#for i in surfaceCount:
			#outlineObj.mesh.surface_set_material(i, outlineMat)
		var outlineMat: Material = preload("res://src/world/outline/outline.tres")
		outlineObj.mesh = meshNode.mesh.duplicate(true)
		outlineObj.mesh.material = outlineMat
	outlineObj.mesh.material.set("shader_parameter/outline_color", color)
	outlineObj.scale = Vector3(size, size, size)
	outlineObj.visible = true

static func hide_3d_outline(meshNode: MeshInstance3D):
	var outlineObj: MeshInstance3D = meshNode.get_node_or_null("_outline")
	if (!outlineObj):
		print("Cannot find created outline object on meshNode " + meshNode.name)
	outlineObj.visible = false
