extends Node2D

@onready var texto_objetivo = $Clown1/Texto
@onready var jokes_pool = []
@onready var score = 0 
@onready var global_core = 0
@onready var letters_score = {}
@onready var keypress_timer = $KeypressedTimer

#var h0
var	quested_text
var hit_index = 0
var used_index = []

@export var move_speed = 200
@export var moving = false
#var destination_position = $Clown1/blue_nose/Marker2D.  .position# .global_position
#var destination_position = $Clown1/blue_nose/Marker2D  # .global_position



#func go_there(delta):
#	if moving:#
#		$Clown1/blue_nose/Marker2D.global_position = $Clown1/blue_nose/Marker2D.move_toward(destination_position , delta*move_speed)

const winning_points = 100
const penalty_points = 5
const keyPress_timeout = 5.0

func init_pool_jokes() -> void:
	var jokes_path = "res://data/jokes.txt"
	#var file = FileAccess.new()
	var file = FileAccess.open(jokes_path, FileAccess.READ)
	if file == null:
		print ("Can't load ", jokes_path)
		return
	while not file.eof_reached(): # iterate through all lines until the end of file is reached
		var line = file.get_line()
		if line.length() > 2:
			jokes_pool.append(line)
	file.close()
	#pull_jokes.append("Jokes are overrated")
	
	#pull_jokes.append("You fight like a clown")
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
	#GlobalVars.texto_objetivo.text = GlobalVars.jokes_pool[indice_random]
	$Clown1/Texto.text = jokes_pool[indice_random]
	quested_text =  $Clown1/Texto.text
	used_index.push_back(indice_random)
	#texto_objetivo.set_visible_characters (texto_objetivo.text.length()) 
	#texto_objetivo = $Combate/Clown1/RichTextLabel
	#texto_objetivo.text = str(0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		print ("Caracter a prueba == %s" % $Clown1/Texto.text.substr(hit_index, 1))
		#if key_typed.to_upper() == texto_objetivo.text.substr(hit_index, 1).to_upper():
		if key_typed.to_upper() == quested_text.substr(hit_index, 1).to_upper():
			#texto_objetivo.visible_characters = texto_objetivo.visible_characters - 1
			#texto_objetivo.set_visible_characters(texto_objetivo.get_visible_characters() - 1)
			hit_index = hit_index + 1 
			$Clown1/Texto.text = quested_text.substr(hit_index, -1)
			#score = score + 1;
			if letters_score.has(key_typed.to_upper()):
				score = score + letters_score.get (key_typed.to_upper())
				keypress_timer.start(keyPress_timeout)
			else:
				score = score + 0
			var score_num = get_node("TextureRect/Num_points");
			$TextureRect/Num_points.text = str(score)
			#Comprobamos si hemos completado la frase y si es asi, emitimos la senyal win.
			if hit_index == quested_text.length():
				#Check de los puntos.
				if score < winning_points:
					var index_rnd = used_index.front()
					while used_index.has(index_rnd):
						index_rnd  = randi() % jokes_pool.size()
					#var indice_random = randi() % jokes_pool.size()
					$Clown1/Texto.text = jokes_pool[index_rnd]
					quested_text =  $Clown1/Texto.text
					hit_index = 0
					used_index.push_back(index_rnd)
				else:
					print ("Se le cae la nariz")
				#Sino, sigues jugando....
		else:
			#en caso de errores#
			hit_index = 0
			#texto_objetivo.set_visible_characters(texto_objetivo.text.length())			
			$Clown1/Texto.text = quested_text
			score = 0	
			$TextureRect/Num_points.text = str(score)
		print("hit index %s " % hit_index)
			#texto_objetivo.text = texto_objetivo.text.substr(1, -1)
		#print ("hit index %s " % hit_index);
			#texto_objetivo.text = texto_objetivo.text.substr(hit_index,-1)
		#var texto = texto_objetivo.text
		#var texto = get_node("Clown1/Texto")
		#print("texto : %s" % texto_objetivo.text)
		#print("El texto del nodo es %s" % $Combate/Clown1/RichTextLabel.text);
		#print("tecla presionada")
		#print("found new enemy that starts with %s" % key_typed)

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
