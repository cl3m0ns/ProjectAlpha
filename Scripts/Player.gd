extends KinematicBody2D

# Declare member variables here
export (int) var speed = 100

var velocity = Vector2()

func get_inputs():
	var tempVelocity = Vector2()
	if Input.is_action_pressed('right'):
		tempVelocity.x += 1
	if Input.is_action_pressed('left'):
		tempVelocity.x -= 1
	if Input.is_action_pressed('down'):
		tempVelocity.y += 1
	if Input.is_action_pressed('up'):
		tempVelocity.y -= 1
	velocity = tempVelocity.normalized() * speed

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle");
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_inputs()
	update_sprite()
	move_and_slide(velocity)

func update_sprite():
	if velocity.x < 0:
		$Sprite.flip_h = true
		$AnimationPlayer.play("Walk")
	elif velocity.x > 0:
		$Sprite.flip_h = false
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle");