extends Node2D

@export var dialog_no_blade: String = "mushroom_no_blade"
@export var dialog_has_blade: String = "mushroom_has_blade"

func _on_interactive_area_2d_interacted() -> void:
	if GameManager.has_blade:
		Dialogic.start(dialog_has_blade)
	else:
		Dialogic.start(dialog_no_blade)
