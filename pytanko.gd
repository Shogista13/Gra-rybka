extends Window
signal answer(point)
var gra = preload("res://gra_rybka.gd")
var zadanko

func ustaw_scene(zadanie):
	zadanko = zadanie
	$Label.set_text(zadanie.tresc)
	$Button.set_text(zadanie.odpowiedzi[0])
	$Button2.set_text(zadanie.odpowiedzi[1])
	$Button3.set_text(zadanie.odpowiedzi[2])
	$Button4.set_text(zadanie.odpowiedzi[3])


func _on_button_pressed() -> void:
	if zadanko.poprawna == str(0):
		print("b")
		answer.emit(1)
	else:
		answer.emit(0)

func _on_button_2_pressed() -> void:
	if zadanko.poprawna == str(1):
		answer.emit(1)
	else:
		answer.emit(0)


func _on_button_3_pressed() -> void:
	if zadanko.poprawna == str(2):
		answer.emit(1)
	else:
		answer.emit(0)

func _on_button_4_pressed() -> void:
	print("a")
	if zadanko.poprawna == str(3):
		answer.emit(1)
	else:
		answer.emit(0)
