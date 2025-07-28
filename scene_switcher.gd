extends Node

const rybka = preload("res://gra_rybka.tscn")
const path = "res://Zadania/"
const res_path = "res://Pytanko.tscn"
const zadanie_klasa = preload("res://Class_zadanie.gd")

var zadania = []
var current_scene

var camera 

func generuj_zadania():
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
	current_scene = rybka.instantiate()
	generuj_zadania()
	get_tree().root.add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func switch_to_exercise():
	call_deferred("_deferred_switch_to_exercise")

func _deferred_switch_to_exercise():
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	var zadanie = zadania.pick_random()
	current_scene.ustaw_scene(zadanie)
	get_tree().root.add_child(current_scene)
	get_tree().change_scene_to_packed(current_scene)
	camera = current_scene.get_node("Camera2D")
	camera.make_current()

func switch_to_rybka():
	call_deferred("_deferred_switch_to_rybka")

func _deferred_switch_to_rybka():
	current_scene.free()
	current_scene = rybka.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().change_scene_to_packed(current_scene)
	camera = current_scene.get_node("Player/Camera2D")
	camera.make_current()
