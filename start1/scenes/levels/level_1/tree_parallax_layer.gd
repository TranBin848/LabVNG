extends ParallaxLayer

@export var opacity: float = 0.6

func _ready():
	for child in get_children():
		if child is CanvasItem:
			child.modulate.a = opacity
		
		# Tắt tất cả CollisionPolygon2D (và CollisionShape2D) trong toàn bộ nhánh con
		for collider in child.get_children():
			_disable_colliders(collider)

func _disable_colliders(node):
	if node is CollisionPolygon2D or node is CollisionShape2D:
		node.disabled = true
	for sub in node.get_children():
		_disable_colliders(sub)
