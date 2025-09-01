extends Node2D

@onready var start_screen = $Start
@onready var pytanko = $Pytanie
@onready var game_over = $Przegrana

var initialized = false
signal stop
signal play_again
var points = 0
var HP = 3

#kliknięcie ESC wyłącza grę
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

#losowa generacja labiryntów

# Ścieżki do labiryntów
var labirynty = [
	preload("res://labirynty/labirynt1.tscn"),
	preload("res://labirynty/labirynt2.tscn"),
	preload("res://labirynty/labirynt3.tscn"),
	preload("res://labirynty/labirynt4.tscn"),
	preload("res://labirynty/labirynt5.tscn"),
	preload("res://labirynty/labirynt6.tscn"),
	preload("res://labirynty/labirynt7.tscn"),
	preload("res://labirynty/labirynt8.tscn"),
	preload("res://labirynty/labirynt9.tscn"),
	preload("res://labirynty/labirynt10.tscn"),
]

#pozycja, w której labirynty mają się pojawić
var siatka_pozycji = [ Vector2i(0, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 0)]

#parametry pozycji w gridze
const TILE_SIZE = 16
const MAZE_TILES = 28

#BŁAGAM NIE DOTYKAĆ TEJ FUNKCJI, BO CAŁĄ NIEDZIELĘ WALCZYŁEM Z OBROTEM LABIRYNTÓW
#I I TAK OSTATECZNIE MUSIAŁEM ICH POZYCJĘ ZAKODOWAĆ NA TWARDO
var aktywnosc_perel = [true,true,true,true]
var instancje_labiryntow = []
@onready var muszle = [$Muszle/muszla,$Muszle/muszla2,$Muszle/muszla3,$Muszle/muszla4]

func generuj_labirynty():
	var rozmiar_labiryntu_px = TILE_SIZE*MAZE_TILES
	
	for i in siatka_pozycji.size():
		if not aktywnosc_perel[i] or not initialized:
			var grid_pos = siatka_pozycji[i]
			var base_pos = Vector2(grid_pos.x*rozmiar_labiryntu_px, grid_pos.y*rozmiar_labiryntu_px)
			
			var losowy_index = randi() % labirynty.size()
			var labirynt_scene = labirynty[losowy_index]
			var instancja = labirynt_scene.instantiate()
			
			var rotation_deg = 0
			if grid_pos == Vector2i(1, 1) or grid_pos == Vector2i(2, 1):
				rotation_deg = 270
			
			instancja.rotation_degrees = rotation_deg
			
			var offset = Vector2.ZERO
			match rotation_deg:
				270:
					offset = Vector2(80-rozmiar_labiryntu_px, 944)
			instancja.position = base_pos + offset
			if not muszle[i].is_connected("body_entered",_on_pearl_collection):
				for instance in instancje_labiryntow:
					if instance.position == base_pos + offset:
						instance.queue_free()
						instancje_labiryntow.erase(instance)
			
			instancje_labiryntow.append(instancja)
			add_child(instancja)
			
			if not muszle[i].is_connected("body_entered",_on_pearl_collection):
				muszle[i].connect("body_entered",_on_pearl_collection)
				var muszla_sprite = muszle[i].get_node("Sprite2D")
				muszla_sprite.show()
				aktywnosc_perel[i] = true
				
		

const base_path = "res://Zadania/"
const zadanie_klasa = preload("res://Class_zadanie.gd")

var zadania = []

func wybierz_zadania():
	var klasa = $Start/VBoxContainer/Level.text
	var temat = $Start/VBoxContainer/Topic.text
	if temat != "wszystko":
		return [base_path+klasa+"/"+temat+"/"]
	else:
		var dir = DirAccess.open(base_path+klasa+"/")
		var paths = []
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			paths.append(base_path+klasa+"/"+file_name+"/")
			file_name = dir.get_next()
		dir.list_dir_end()
		return paths

func generuj_zadania():
	var path = wybierz_zadania()
	for i in path:
		var dir = DirAccess.open(i)
		var zadanie
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var file = FileAccess.open(i+file_name, FileAccess.READ).get_as_text().split("\n")
			zadanie = zadanie_klasa.new(file[0],file.slice(1,-2),file[-2])
			zadania.append(zadanie)
			file_name = dir.get_next()
		dir.list_dir_end()

func _ready():
	start_screen.show()
	game_over.hide()
	
func _on_start_pressed() -> void:
	start_screen.hide()
	randomize()
	generuj_labirynty()
	generuj_zadania()
	await get_tree().create_timer(0.1).timeout
	pytanko.hide()
	$Player/Camera2D/Label.set_text("Punkty: "+str(points)+" HP: "+str(HP))
	initialized = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_pearl_collection(body: Node2D) -> void:
	if initialized:
		stop.emit()
		var task = zadania.pick_random()	
		zadania.erase(task)
		if len(zadania) == 0:
			generuj_zadania()
		pytanko.ustaw_scene(task)
		pytanko.show()

func _on_muszla_body_entered(body: Node2D) -> void:
	if initialized:
		generuj_labirynty()
		$Muszle/muszla.disconnect("body_entered",_on_pearl_collection)
		$Muszle/muszla/Sprite2D.hide()
		aktywnosc_perel[0] = false

func _on_muszla_2_body_entered(body: Node2D) -> void:
	if initialized:
		generuj_labirynty()
		$Muszle/muszla2.disconnect("body_entered",_on_pearl_collection)
		$Muszle/muszla2/Sprite2D.hide()
		aktywnosc_perel[1] = false

func _on_muszla_3_body_entered(body: Node2D) -> void:
	if initialized:
		generuj_labirynty()
		$Muszle/muszla3.disconnect("body_entered",_on_pearl_collection)
		$Muszle/muszla3/Sprite2D.hide()
		aktywnosc_perel[2] = false

func _on_muszla_4_body_entered(body: Node2D) -> void:
	if initialized:
		generuj_labirynty()
		$Muszle/muszla4.disconnect("body_entered",_on_pearl_collection)
		$Muszle/muszla4/Sprite2D.hide()
		aktywnosc_perel[3] = false

func _on_pytanie_answer(point):
	if point == 1:
		points += 1
		if points % 3 == 0:
			HP += 1
	else:
		HP -= 1
		if HP == 0:
			przegrana()
	pytanko.hide()
	$Player/Camera2D/Label.set_text("Points: "+str(points)+" HP: "+str(HP))

func _on_add_exercises_pressed() -> void:
	start_screen.hide()

func przegrana():
	$Przegrana/VBoxContainer/VSplitContainer2/VSplitContainer/Punkty.set_text("Punkty " + str(points))
	game_over.show()
	stop.emit()

func _on_play_again_pressed() -> void:
	points = 0
	HP = 3
	play_again.emit()
	game_over.hide()
