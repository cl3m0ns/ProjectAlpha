extends KinematicBody2D

# Declare member variables here
export (int) var speed = 75

var velocity = Vector2()
var lastVelocity = Vector2(0,0)
var lastAnimation = "Idle"

enum facings { up, down, left, right }
enum states { idle, walk, attack }


var FACING = facings.right
var STATE
var PREV_STATE
var NEXT_STATE = states.idle

# Called when the node enters the scene tree for the first time.
func _ready():
	idle_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	STATE = NEXT_STATE
	if STATE == states.idle:
		idle_state()
	elif STATE == states.walk:
		walk_state()
	elif STATE == states.attack:
		attack_state()


func set_last_animation_and_velocity():
	lastAnimation = $AnimationPlayer.get_current_animation()
	lastVelocity = velocity;


func get_inputs():
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var attack = Input.is_action_just_pressed("attack")
	
	if attack:
		NEXT_STATE = states.attack
	elif right || left || up || down:
		NEXT_STATE = states.walk
	else:
		NEXT_STATE = states.idle
	
	PREV_STATE = STATE


#########################################################
###  ATTACK STATE #######################################
#########################################################
func attack_state():
	set_last_animation_and_velocity()
	update_attack_sprite()
	PREV_STATE = STATE
	pass

func update_attack_sprite():
	#make sure we we're already attack
	if PREV_STATE != states.attack:
		if FACING == facings.right:
			$AnimationPlayer.play("Attack")
			$Sprite.flip_h = false
		elif FACING == facings.left:
			$AnimationPlayer.play("Attack")
			$Sprite.flip_h = true
		elif FACING == facings.up:
			$AnimationPlayer.play("Attack Up")
		elif FACING == facings.down:
			$AnimationPlayer.play("Attack Down")
	elif !$AnimationPlayer.is_playing():
		#figure out next state if attack ends
		get_inputs()
#########################################################



#########################################################
###### IDLE STATE #######################################
#########################################################
func idle_state():
	$AnimationPlayer.play("Idle");
	set_last_animation_and_velocity()
	
	get_inputs()
#########################################################



#########################################################
###### WALK STATE #######################################
#########################################################
func walk_state():
	get_movement()
	update_walk_sprite()
	move_and_slide(velocity, Vector2.ZERO)
	
	get_inputs()

func get_movement():
	var tempVelocity = Vector2()
	var left = Input.is_action_pressed('left')
	var right = Input.is_action_pressed('right')
	var down = Input.is_action_pressed('down')
	var up = Input.is_action_pressed('up')
	
	velocity.x = -int(left) + int(right)
	velocity.y = -int(up) + int(down)
	velocity = velocity.normalized() * speed

func update_walk_sprite():
	var movingHorizontal = false
	var movingVertical = false
	if lastVelocity.x != 0:movingHorizontal = true
	if lastVelocity.y != 0:movingVertical = true
	
	if velocity.x < 0 && !movingVertical:
		$Sprite.flip_h = true
		$AnimationPlayer.play("Walk")
		FACING = facings.left
	elif velocity.x > 0 && !movingVertical:
		$Sprite.flip_h = false
		$AnimationPlayer.play("Walk")
		FACING = facings.right
	elif velocity.y > 0 && !movingHorizontal:
		$AnimationPlayer.play("Walk Down")
		FACING = facings.down
	elif velocity.y < 0 && !movingHorizontal:
		$AnimationPlayer.play("Walk Up")
		FACING = facings.up
	elif velocity.y == 0 && velocity.x == 0:
		NEXT_STATE = states.idle
		PREV_STATE = STATE
	else:
		$AnimationPlayer.play(lastAnimation)
	
	set_last_animation_and_velocity()
###########################################################