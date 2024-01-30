extends Node2D

@onready var texto_objetivo = $Clown1/Texto
@onready var keypress_timer = $KeypressedTimer


@onready var jokes_pool = []
@onready var score = 0 
@onready var global_core = 0
@onready var letters_score = {}


const COLOR_RED = Color(1.0,0.0,0.0)
const COLOR_BLUE = Color(0.0,0.0,1.0)
const COLOR_GREEN = Color(0.0,1.0,0.0)
const COLOR_WHITE = Color(1.0,1.0,1.0)
const COLOR_ORANGE = Color(1.0,0.55,0.0)

var	quested_text
var hit_index = 0
var used_index = []

#@export var move_speed = 200
#@export var moving = false
#var destination_position = $Clown1/blue_nose/Marker2D.  .position# .global_position
#var destination_position = $Clown1/blue_nose/Marker2D  # .global_position

#func go_there(delta):
#	if moving:#
#		$Clown1/blue_nose/Marker2D.global_position = $Clown1/blue_nose/Marker2D.move_toward(destination_position , delta*move_speed)

const winning_points = 100
const penalty_points = 5
const keyPress_timeout = 1.5

func init_pool_jokes() -> void:
	var jokes_path = "res://data/jokes.txt"
	var file = FileAccess.open(jokes_path, FileAccess.READ)
	if file == null:
		print ("Can't load ", jokes_path)
		return
	while not file.eof_reached(): # iterate through all lines until the end of file is reached
		var line = file.get_line()
		if line.length() > 2:
			jokes_pool.append(line)
	file.close()

func init_scores():
	var scores_path = "res://data/letter_points.txt"
	var  file = FileAccess.open(scores_path, FileAccess.READ)
	if file == null:
		print ("Can't load ", scores_path)
		return
	while not file.eof_reached(): 
		var line = file.get_line()
		var letter_score_array = line.split("\t", true, 0)
		if letter_score_array.size() == 2:
			var letter  = letter_score_array[0].to_upper()
			var l_score	= int(letter_score_array[1])
			letters_score[letter] = l_score
	file.close()
		
func  _ready():
	init_pool_jokes()
	init_scores()
	var indice_random = randi() % jokes_pool.size()
	texto_objetivo.text = jokes_pool[indice_random]
	quested_text =  texto_objetivo.text
	used_index.push_back(indice_random)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		print ("Caracter a prueba == %s" % texto_objetivo.text.substr(hit_index, 1))
		if key_typed.to_upper() == quested_text.substr(hit_index, 1).to_upper():
			hit_index = hit_index + 1 
			texto_objetivo.text = quested_text.substr(hit_index, -1)
			if letters_score.has(key_typed.to_upper()):
				score = score + letters_score.get (key_typed.to_upper())
				keypress_timer.start(keyPress_timeout)
			else:
				score = score + 0
			var score_num = get_node("TextureRect/Num_points");
			$TextureRect/Num_points.text = str(score)
			_set_score_color()
			#Comprobamos si hemos completado la frase y si es asi, emitimos la senyal win.
			if hit_index == quested_text.length():
				#Check de los puntos.
				if score < winning_points:
					var index_rnd = used_index.front()
					while used_index.has(index_rnd):
						index_rnd  = randi() % jokes_pool.size()
					texto_objetivo.text = jokes_pool[index_rnd]
					quested_text =  texto_objetivo.text
					hit_index = 0
					used_index.push_back(index_rnd)
				else:
					get_tree().change_scene_to_file("res://primer intento.tscn")
					#print ("Se le cae la nariz")
				#Sino, sigues jugando....
		else:
			#en caso de errores#
			hit_index = 0
			texto_objetivo.text = quested_text
			score = 0	
			$TextureRect/Num_points.text = str(score)
			_set_score_color()
		print("hit index %s " % hit_index)

# Called when the node enters the scene tree for the first time.
#func _ready():
	##pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass#


func _on_keypressed_timer_timeout():
	hit_index = 0
	texto_objetivo.text = quested_text
	 # Replace with function body.


func _set_score_color() -> void:
	if (score >= winning_points):
		$TextureRect/Num_points.set("theme_override_colors/font_color",COLOR_RED)
		return
	if (score >= 2 * winning_points / 3):
		$TextureRect/Num_points.set("theme_override_colors/font_color",COLOR_ORANGE)
		return
	if (score >= winning_points / 3):
		$TextureRect/Num_points.set("theme_override_colors/font_color",COLOR_GREEN)
		return
	else:
		$TextureRect/Num_points.set("theme_override_colors/font_color",COLOR_WHITE)
		return
