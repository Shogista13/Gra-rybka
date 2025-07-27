extends Node2D

#funkcja powoduje, że kliknięcie ESC wyłącza grę
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
