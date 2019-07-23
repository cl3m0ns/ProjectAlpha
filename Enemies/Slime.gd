extends "res://Enemies/Enemy.gd"


func set_last_animation_and_velocity():
	lastAnimation = $AnimationPlayer.get_current_animation()
	lastVelocity = velocity;

func on_wander_timeout_complete():
	NEXT_STATE = states.idle

func on_idle_timeout_complete():
	idle_time_over = true

func set_up_timers():
	wander_time_timer = Timer.new()
	wander_time_timer.set_one_shot(true)
	wander_time_timer.set_wait_time(wander_time)
	wander_time_timer.connect("timeout", self, "on_wander_timeout_complete")
	add_child(wander_time_timer)
	
	idle_time_timer = Timer.new()
	idle_time_timer.set_one_shot(true)
	idle_time_timer.set_wait_time(idle_time)
	idle_time_timer.connect("timeout", self, "on_idle_timeout_complete")
	add_child(idle_time_timer)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up_timers()
	idle_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	STATE = NEXT_STATE
	if STATE == states.idle:
		idle_state()
	elif STATE == states.attack:
		attack_state()
	elif STATE == states.hurt:
		hurt_state()
	elif STATE == states.roam:
		roam_state()


#########################################################
###### IDLE STATE #######################################
#########################################################
func idle_state():
	$AnimationPlayer.play("idle")
	set_last_animation_and_velocity()
	print(idle_time_timer.time_left)
	if idle_time_over:
		randomize() #ensures the numbers are randomized each time the function is run
		var nextState = [states.roam, states.idle, states.idle, states.idle]
		NEXT_STATE = nextState[randi() % nextState.size()]
		idle_time_over = false
	elif idle_time_timer.is_stopped():
		idle_time_timer.start()
#########################################################


#########################################################
###### HURT STATE #######################################
#########################################################
func attack_state():
	pass	
#########################################################


#########################################################
###### HURT STATE #######################################
#########################################################
func hurt_state():
	pass
#########################################################



#########################################################
###### ROAM STATE #######################################
#########################################################
func roam_state():
	wander_time_timer.start()
	get_movement()
	update_roam_sprite()
	move_and_slide(velocity)

func update_roam_sprite():
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
		$AnimationPlayer.play("Walk")
		FACING = facings.down
	elif velocity.y < 0 && !movingHorizontal:
		$AnimationPlayer.play("Walk")
		FACING = facings.up
	else:
		$AnimationPlayer.play(lastAnimation)

func get_movement():
	var tempVelocity = Vector2()
	var nextX = [-1, 0, 1]
	var nextY = [-1, 0, 1]
	tempVelocity.x += nextX[randi() % nextX.size()]
	tempVelocity.y += nextY[randi() % nextY.size()]
	velocity = tempVelocity.normalized() * speed
#########################################################