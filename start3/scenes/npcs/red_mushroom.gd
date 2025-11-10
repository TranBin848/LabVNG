extends Node2D

@export var hoithoai: String = "10hoithoai"

func _on_interactive_area_2d_interacted() -> void:
	Dialogic.start(hoithoai)
