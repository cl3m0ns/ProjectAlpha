extends KinematicBody2D

# Declare member variables here
export (int) var speed = 75

var velocity = Vector2()
var lastVelocity = Vector2(0,0)
var lastAnimation

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
	lastAnimation = $AnimationPlayer.get_current_animation()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_inputs()
	update_sprite()
	move_and_slide(velocity)

func update_sprite():
	var movingHorizontal = false
	var movingVertical = false
	if lastVelocity.x != 0:movingHorizontal = true
	if lastVelocity.y != 0:movingVertical = true
	
	if velocity.x < 0 && !movingVertical:
		$Sprite.flip_h = true
		$AnimationPlayer.play("Walk")
	elif velocity.x > 0 && !movingVertical:
		$Sprite.flip_h = false
		$AnimationPlayer.play("Walk")
	elif velocity.y > 0 && !movingHorizontal:
		$AnimationPlayer.play("Walk Down")
	elif velocity.y < 0 && !movingHorizontal:
		$AnimationPlayer.play("Walk Up")
	elif velocity.y == 0 && velocity.x == 0:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play(lastAnimation)
	
	lastAnimation = $AnimationPlayer.get_current_animation()
	lastVelocity = velocity;