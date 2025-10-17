extends RigidBody2D

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_hit_area_2d_area_entered(area: Area2D) -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	queue_free()
