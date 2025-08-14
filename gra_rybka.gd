extends Node2D

@onready var start_screen = $Start
@onready var pytanko = $Pytanie

signal stop
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
func generuj_labirynty():
	var rozmiar_labiryntu_px = TILE_SIZE*MAZE_TILES
	
	for i in siatka_pozycji.size():
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
		add_child(instancja)

var initialized = false
const base_path = "res://Zadania/"
var path
const zadanie_klasa = preload("res://Class_zadanie.gd")

var zadania = []

func wybierz_zadania():
	var klasa = $Start/VBoxContainer/Level.text
	var temat = $Start/VBoxContainer/Topic.text
	path = base_path+klasa+"/"
	if temat != "wszystko":
		path+=temat+"/"

func generuj_zadania():
	wybierz_zadania()
	var dir = DirAccess.open(path)
	var zadanie
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file = FileAccess.open(path+file_name, FileAccess.READ).get_as_text().split("\n")
		zadanie = zadanie_klasa.new(file[0],file.slice(1,-2),file[-2])
		zadania.append(zadanie)
		file_name = dir.get_next()

func _ready():
	start_screen.show()
	
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
		generuj_labirynty()

func _on_muszla_body_entered(body: Node2D) -> void:
	if initialized:
		$Muszle/muszla.disconnect("body_entered",_on_pearl_collection)
		$Muszle/muszla/Sprite2D.hide()
		if not $Muszle/muszla2/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla2.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla2/Sprite2D.show()
		if not $Muszle/muszla3/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla3.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla3/Sprite2D.show()
		if not $Muszle/muszla4/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla4.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla4/Sprite2D.show()
			

func _on_muszla_2_body_entered(body: Node2D) -> void:
	if initialized:
		$Muszle/muszla2.disconnect("body_entered",_on_pearl_collection)
		$Muszle/muszla2/Sprite2D.hide()
		if not $Muszle/muszla/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla/Sprite2D.show()
		if not $Muszle/muszla3/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla3.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla3/Sprite2D.show()
		if not $Muszle/muszla4/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla4.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla4/Sprite2D.show()
			

func _on_muszla_3_body_entered(body: Node2D) -> void:
	if initialized:
		$Muszle/muszla3.disconnect("body_entered",_on_pearl_collection)
		$Muszle/muszla3/Sprite2D.hide()
		if not $Muszle/muszla/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla/Sprite2D.show()
		if not $Muszle/muszla2/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla2.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla2/Sprite2D.show()
		if not $Muszle/muszla4/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla4.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla4/Sprite2D.show()

func _on_muszla_4_body_entered(body: Node2D) -> void:
	if initialized:
		$Muszle/muszla4.disconnect("body_entered",_on_pearl_collection)
		$Muszle/muszla4/Sprite2D.hide()
		if not $Muszle/muszla/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla/Sprite2D.show()
		if not $Muszle/muszla2/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla2.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla2/Sprite2D.show()
		if not $Muszle/muszla3/Sprite2D.is_connected("body entered",_on_pearl_collection):
			$Muszle/muszla3.connect("body_entered",_on_pearl_collection)
			$Muszle/muszla3/Sprite2D.show()


func _on_pytanie_answer(point):
	if point == 1:
		points += 1
	else:
		HP -= 1
	pytanko.hide()
	$Player/Camera2D/Label.set_text("Points: "+str(points)+" HP: "+str(HP))

func _on_add_exercises_pressed() -> void:
	start_screen.hide()
