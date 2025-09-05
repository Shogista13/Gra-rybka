extends HSlider

@export var bus_name: String

var bus_index

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)

func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db)
