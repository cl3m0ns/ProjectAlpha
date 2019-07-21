extends KinematicBody2D

# Declare member variables here
export (int) var speed = 75

var velocity = Vector2()
var lastVelocity = Vector2(0,0)
var lastAnimation = "Idle"

const facing = {
	left = "left",
	right = "right",
	up = "up",
	down = "down"
}

const states = {
	idle="Idle",
	walk="Walk",
	attack="Attack" 
}

var STATE = "";
var PREV_STATE = "";
var NEXT_STATE = states.idle;

# Called when the node enters the scene tree for the first time.
func _ready():
	idle_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	STATE = NEXT_STATE
	get_inputs()
	
	if STATE == states.idle:
		idle_state()
	elif STATE == states.walk:
		walk_state()
	elif STATE == states.attack:
		attack_state()

func idle_state():
	$AnimationPlayer.play("Idle");
	set_last_animation_and_velocity()

func walk_state():
	get_movement()
	update_sprite()
	move_and_slide(velocity)

func attack_state():
	set_last_animation_and_velocity()
	pass

func set_last_animation_and_velocity():
	lastAnimation = $AnimationPlayer.get_current_animation()
	lastVelocity = velocity;

func get_movement():
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

func get_inputs():
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var attack = Input.is_action_pressed("attack")
	
	if attack:
		NEXT_STATE = states.attack
	elif right || left || up || down:
		NEXT_STATE = states.walk
	else:
		NEXT_STATE = states.idle
	
	PREV_STATE = STATE

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
		NEXT_STATE = states.idle
		PREV_STATE = STATE
	else:
		$AnimationPlayer.play(lastAnimation)
	
	set_last_animation_and_velocity()