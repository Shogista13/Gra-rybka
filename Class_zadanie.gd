extends RefCounted
class_name zadanie_klasa

var odpowiedzi: PackedStringArray
var poprawna: String
var zakresy
var tresc_zadanka: String

func generuj_losowe_liczby(tresc_zadania,odczytane_zakresy):
	var tresc = tresc_zadania.split("_")
	var lista_wylosowanych_liczb = []
	var wylosowana_tresc = ""
	for i in range(len(tresc)):
		wylosowana_tresc += tresc[i]
		if i < len(tresc)-1 and len(tresc)>1:
			var wylosowana = wylosuj_liczbe(odczytane_zakresy,lista_wylosowanych_liczb,i)
			wylosowana_tresc += str(wylosowana)
			lista_wylosowanych_liczb.append(wylosowana)
	return [wylosowana_tresc,lista_wylosowanych_liczb]

func czytaj_zakresy(zakresy):
	var podzielone_zakresy = []
	for boundary in range(len(zakresy)/2):
		podzielone_zakresy.append([zakresy[2*boundary],zakresy[2*boundary+1]])
	return podzielone_zakresy

func wylosuj_liczbe(zakresy,wczesniej_wylosowane,numer):
	var zakres_nieprzetlumaczone = zakresy[numer]
	var zakres = []
	for granica in range(len(zakres_nieprzetlumaczone)):
		if zakres_nieprzetlumaczone[granica].contains("_"):
			numer = int(zakres_nieprzetlumaczone[granica].trim_prefix("_"))
			zakres.append(int(wczesniej_wylosowane[numer]))
		else:
			zakres.append(int(zakres_nieprzetlumaczone[granica]))
	var number = randi() % (zakres[1]-zakres[0]) + zakres[0]
	return number

func oblicz_wartosc(wyrazenie):
	var expression = Expression.new()
	expression.parse(wyrazenie)
	return expression.execute()

func generuj_odpowiedzi(answer:String,liczby:Array):
	for number in range(len(liczby)):
		while answer.contains("_"+str(number)):
			answer = answer.replace("_"+str(number),str(liczby[number]))
	var correct_answer = oblicz_wartosc(answer)
	var index = randi() % 4
	var odpowiedzi = []
	for i in range(4):
		if i == index:
			odpowiedzi.append(str(correct_answer))
		else:
			var error = randi() % 8 - 4
			while odpowiedzi.has(correct_answer+error) or error == 0:
				error = randi() % 8 - 4
			odpowiedzi.append(str(correct_answer+error))
	return [odpowiedzi,index]

func _init(tresc_zadanka: String,zakresy:PackedStringArray,odpowiedz: String):
	self.zakresy = czytaj_zakresy(zakresy)
	var results = generuj_losowe_liczby(tresc_zadanka,self.zakresy)
	self.tresc_zadanka = results[0]
	results = generuj_odpowiedzi(odpowiedz,results[1])
	self.odpowiedzi = results[0]
	self.poprawna = str(results[1])
	
