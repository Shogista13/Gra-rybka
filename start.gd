extends Window

@onready var start_button = $VBoxContainer/Start
@onready var choose_level = $VBoxContainer/Level
@onready var choose_topic = $VBoxContainer/Topic
@onready var quit_button = $VBoxContainer/Quit

const levels = {
	"klasa 1":["dodawanie","mnożenie"],
	"klasa 2":["geometria","dzielenie"]
}

var dict_keys = levels.keys()

var button_color = "#c8c800" 

func _ready() -> void:
	for key in dict_keys:
		choose_level.add_item(key)
	for topic in levels[dict_keys[0]]:
		choose_topic.add_item(topic)
	choose_level.allow_reselect = true
	choose_topic.allow_reselect = true
	start_button.set_text("Zacznij grę")
	quit_button.set_text("Wyjdź")
	var style = start_button.get_theme_stylebox("normal")
	style.bg_color = button_color
	start_button.add_theme_stylebox_override("normal", style)
	var style_option = choose_level.get_theme_stylebox("normal")
	style_option.bg_color = button_color

func _on_level_item_selected(index: int) -> void:
	choose_topic.clear()
	for topic in levels[dict_keys[index]]:
		choose_topic.add_item(topic)
	choose_topic.add_item("wszystko")
