extends Window

@onready var start_button = $"../Start"
@onready var settings_button = $"."


func _on_return_pressed() -> void:
	settings_button.hide()
	start_button.show()
