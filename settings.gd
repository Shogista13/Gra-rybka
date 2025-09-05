extends Window

@onready var start_button = $"../Start"
@onready var pause_button = $"../Pause"
@onready var settings_button = $"."

var start_or_pause = "start"

func _on_gra_rybka_start_or_pause() -> void:
	start_or_pause ="pause"

func _on_return_pressed() -> void:
	settings_button.hide()
	if start_or_pause == "start":
		start_button.show()
	elif start_or_pause == "pause":
		pause_button.show()
