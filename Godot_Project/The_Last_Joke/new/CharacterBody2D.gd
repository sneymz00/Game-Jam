extends CharacterBody2D

var speed = 45
var acceleration = 20

#func _ready():
	#screen_size = get_viewport_rect().size
	

func _physics_process(delta):
	var input_dir = Vector2()
	
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	#print(input_dir)
	velocity = input_dir.normalized() * 500
	print(input_dir)
	move_and_slide()
	
	#position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	
