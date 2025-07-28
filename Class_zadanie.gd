extends RefCounted
class_name zadanie_klasa

var tresc: String
var odpowiedzi: PackedStringArray
var poprawna: String
var zakresy

func generuj_losowe_liczby(tresc,zakresy):
	tresc = tresc.split("_")
	var wylosowana_tresc: String
	for i in range(len(tresc)):
		wylosowana_tresc += tresc[i]
		if i < len(tresc) and len(tresc)>1:
			var zakres = zakresy[i]
			var number = randi() % (zakres[1]-zakres[0]) + zakres[0]
			wylosowana_tresc += str(number)
	return wylosowana_tresc

func _init(tresc: String, odpowiedzi: PackedStringArray,poprawna: String,zakresy = null):
	self.odpowiedzi = odpowiedzi
	self.poprawna = poprawna
	self.tresc = generuj_losowe_liczby(tresc,zakresy)
	
