extends CharacterBody2D

var speed = 45
var acceleration = 20

func _physics_process(delta):
	var input_dir = Vector2()
	
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	print(input_dir)
	velocity = input_dir.normalized() * 200
	move_and_slide()
	#velocity = velocity.move_toward(input_dir * speed, acceleration)
	#velocity = move_and_slide()
	
