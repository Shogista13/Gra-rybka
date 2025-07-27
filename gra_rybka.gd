extends Node2D

#kliknięcie ESC wyłącza grę
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

#losowa generacja labiryntów

# Ścieżki do labiryntów
var labirynty = [
	preload("res://labirynty/labirynt1.tscn"),
	preload("res://labirynty/labirynt2.tscn"),
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
	
func _ready():
	randomize()
	generuj_labirynty()
